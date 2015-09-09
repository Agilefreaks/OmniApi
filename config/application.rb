$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app', 'api'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV['RACK_ENV']

base_path = Pathname.new(File.expand_path(File.dirname(__FILE__))).join('../')

# require initializers
Dir.glob(base_path.join('config', 'initializers', '*.rb')).each { |f| require f }

# require all the rest
include_dirs = %w(models interactions finders factories builders services repositories)
include_dirs.each do |dir|
  Dir.glob(base_path.join('app', dir, '**', '*.rb')).each { |f| require f }
end

# require omni_sync
require base_path.join('lib', 'omni_sync').to_s

# boot up the app
require base_path.join('app', 'omniapi_app').to_s
