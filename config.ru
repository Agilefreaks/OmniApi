require File.expand_path('../config/environment', __FILE__)

# Manually start the newrelic agent
NewRelic::Agent.manual_start

run OmniApi::App.instance