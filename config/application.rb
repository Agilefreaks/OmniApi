$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app', 'api'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

# require initializers
current_dir = Pathname.new(__FILE__).dirname
Dir[current_dir.join('initializers', '*.rb')].each { |file| require file }

# require all the rest
include_dirs = %w(models
                  interactions interactions/call interactions/sms interactions/oauth
                  finders
                  factories
                  builders
                  services
                  repositories)

include_dirs.each do |dir|
  Dir[current_dir.join('..', 'app', dir, '*.rb')].each { |f| require f }
end

# require omni_sync
require_relative '../lib/omni_sync'

# boot up the app
require File.expand_path('../../app/omniapi_app.rb', __FILE__)
