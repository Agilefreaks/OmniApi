$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app', 'api'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

# require initializers
Dir[Pathname.new(__FILE__).dirname.join('initializers', '*.rb')].each do |file|
  require file
end

# require all the rest
include_dirs = %w(models interactions)

include_dirs.each do |dir|
  Dir[Pathname.new(__FILE__).dirname.join('..', 'app', dir, '*.rb')].each do |f|
    require f
  end
end

Mongoid.load!(File.expand_path('../mongoid.yml', __FILE__))

require File.expand_path('../../app/omniapi_app.rb', __FILE__)
