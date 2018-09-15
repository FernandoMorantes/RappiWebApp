require 'pg'

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
        puts "Data row #{i} :\n id: #{ row['id']}\n storekeeper id: #{row['storekeeper_id']}\n latitud: #{row['lat']}\n longitud: #{row['lng']}\n timestamp: #{row['timestamp']}\n toolkit: #{row['toolkit']}\n" if i < 1
    end


rescue PG::Error => e
    puts "#{e.message} no funciona esta puta mierda"

ensure
    connection.close if connection
end
