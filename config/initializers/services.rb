services_path = '../../lib/services'

initializers = Dir["#{File.dirname(__FILE__)}/#{services_path}/*.rb"]

initializers.each { |initializer| require initializer }
