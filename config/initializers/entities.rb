entities_path = '../../lib/entities'

initializers = Dir["#{File.dirname(__FILE__)}/#{entities_path}/*.rb"]

require_relative './gems.rb'
initializers.each { |initializer| require initializer }
