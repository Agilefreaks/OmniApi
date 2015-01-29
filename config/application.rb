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
include_dirs = %w(models interactions finders factories builders services repositories)

include_dirs.each do |dir|
  Dir[Pathname.new(__FILE__).dirname.join('..', 'app', dir, '*.rb')].each do |f|
    require f
  end
end

# require omni_sync
require_relative '../lib/omni_sync'

# mongo configuration
Mongoid.load!(File.expand_path('../mongoid.yml', __FILE__))

# boot up the app
require File.expand_path('../../app/omniapi_app.rb', __FILE__)

OmniKiq.configure do |config|
  settings = YAML.load_file(File.expand_path('../omnikiq.yml', __FILE__))[ENV['RACK_ENV']]
  config.redis_namespace = settings['redis_namespace']
  config.redis_url = settings['redis_url']
end
