require 'pg'
require 'mongo'
require 'erb'
require 'rack'
require 'httparty'

class PostgresData

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
        puts 'Successfully created connection to database.'

        resultSet = connection.exec('SELECT * from storekeepers;')
        resultSet.each_with_index do |row, i|
            @dataPostgres << "Data row #{i} :\n id: #{ row['id']}\n storekeeper id: #{row['storekeeper_id']}\n latitud: #{row['lat']}\n longitud: #{row['lng']}\n timestamp: #{row['timestamp']}\n toolkit: #{row['toolkit']}\n" if i < 1
        end

    rescue PG::Error => e
        puts "#{e.message} no funciona esta puta mierda"

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

      mongoResultQuery.each_with_index do |data, i|
        @dataMongo << JSON.parse(data.to_json) if i < 1
      end

      client.close
    rescue StandardError => err
      puts('Error: ')
      puts(err)
    end

    if env['PATH_INFO'] == '/'
      body = ERB.new(File.read('index.html.erb'))
      [200, {}, [body.result(binding)]]
    else
      [404, {}, ['Pagina no encontrada']]
    end
  end
end

run PostgresData
