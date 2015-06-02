require File.expand_path('../config/environment', __FILE__)

# Manually start the newrelic agent
NewRelic::Agent.manual_start(env: ENV['RACK_ENV'])

run OmniApi::App.instance
