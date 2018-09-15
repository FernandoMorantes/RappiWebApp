require 'pg'

begin
    # Initialize connection variables.
    host = String('postgres-hackathon.eastus2.cloudapp.azure.com')
    database = String('storekeepersdb')
    user = String('hackathonpostgres')
    password = String('<hackathon2018rappisql>')

    # Initialize connection object.
    connection = PG::Connection.new(:host => host, :user => user, :dbname => database, :port => '5432', :password => password)
    puts 'Successfully created connection to database.'

    
rescue PG::Error => e
    puts e.message

ensure
    connection.close if connection
end
