#!/usr/bin/env puma

directory '/var/www/omniapi/current'
rackup '/var/www/omniapi/current/config.ru'
environment ENV['RACK_ENV']

pidfile '/var/www/omniapi/shared/tmp/pids/puma.pid'
state_path '/var/www/omniapi/shared/tmp/pids/puma.state'
stdout_redirect '/var/www/omniapi/shared/log/puma_access.log', '/var/www/omniapi/shared/log/puma_error.log', true

threads 0, 2

bind 'unix:/var/www/omniapi/shared/tmp/sockets/puma.sock'
workers 2

preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV['BUNDLE_GEMFILE'] = '/var/www/omniapi/current/Gemfile'
end
