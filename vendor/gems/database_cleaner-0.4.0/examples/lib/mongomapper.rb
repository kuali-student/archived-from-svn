require 'mongo_mapper'

::MongoMapper.connection = Mongo::Connection.new('127.0.0.1')
::MongoMapper.database = 'database_cleaner_test'

class Widget
  include MongoMapper::Document
  key :id, Integer
  key :name, String
end
