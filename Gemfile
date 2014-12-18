source 'http://rubygems.org'
ruby '2.1.5'

gem 'puma'

gem 'grape', '~> 0.9'
gem 'grape-entity'
gem 'grape-swagger'

gem 'mongoid', '4.0.0'

gem 'bundler'
gem 'rake'

gem 'json'

gem 'rack-cors'
gem 'rack-oauth2'

gem 'gcm'

gem 'newrelic_rpm', '3.9.7.266'
gem 'newrelic-grape'

gem 'mixpanel-ruby'

group :development, :test do
  gem 'pry'
  gem 'rb-fsevent'
  gem 'growl'
  gem 'rubocop'
  gem 'rerun'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-rubocop'

  # deploy
  gem 'capistrano', '~> 3.3', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano3-puma', require: false
end

group :test do
  gem 'rspec'
  gem 'rspec-mocks'
  gem 'rspec-its'
  gem 'json_spec'
  gem 'rack-test'
  gem 'fabrication'
  gem 'database_cleaner'
  gem 'simplecov'
  gem 'simplecov-teamcity-summary'
  gem 'mongoid-rspec', '~> 2.0.0.rc1'
end
