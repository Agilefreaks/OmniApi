require 'rubygems'

ENV['RACK_ENV'] ||= 'test'

require 'rack/test'

require File.expand_path('../../config/environment', __FILE__)

# Require all of the RSpec Support libraries
Dir[File.expand_path(File.join('../support/**/*.rb'), __FILE__)].each { |f| require f }

Dir[File.expand_path(File.join('../../lib/jobs/**/*.rb'), __FILE__)].each { |f| require f }

require 'simplecov'
SimpleCov.start 'teamcity'
