require 'pg'
require 'mongo'
require 'erb'
require 'rack'
require 'sass'
require 'sass/plugin/rack'

use Sass::Plugin::Rack

class Main

  def self.call env

    @dataPostgres = []
    @dataMongo = []
    begin
        # Initialize connection variables.
        host = String('postgres-hackathon.eastus2.cloudapp.azure.com')
        database = String('storekeepersdb')
        user = String('hackathonpostgres')
        password = String('hackathon2018rappipsql')

        # Initialize connection object.
        connection = PG::Connection.new(:host => host, :user => user, :dbname => database, :port => '5432', :password => password)

        resultSet = connection.exec('SELECT * from storekeepers;')
        resultSet.each do |row|
            @dataPostgres << [row['id'], row['storekeeper_id'], row['lat'], row['lng'], row['timestamp'], row['toolkit']]
        end

    rescue PG::Error => e
        puts "#{e.message}"

    ensure
        connection.close if connection
    end

    Mongo::Logger.logger.level = Logger::WARN

      client_host = 'mongodb://hackathonmongo:hackathon2018rappimongodb@mongo-hackathon.eastus2.cloudapp.azure.com:27017/orders'
      client_options = {
      database: 'orders',
      user: 'hackathonmongo',
      password: 'hackathon2018rappimongodb'
    }

    begin
      client = Mongo::Client.new(client_host, client_options)

      mongoResultQuery = client.database['orders'].find( {} ).to_a

      mongoResultQuery.each do |data|
        @dataMongo << JSON.parse(data.to_json)
      end

      client.close
    rescue StandardError => err
      puts('Error: ')
      puts(err)
    end

    body = ERB.new(File.read('Index.html.erb'))
    [200, {}, [body.result(binding)]]
  end
end

run Main
