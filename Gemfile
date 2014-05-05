source 'http://rubygems.org'
ruby '2.1.1'

gem 'puma'

gem 'grape', '~> 0.7'
gem 'grape-entity'
gem 'grape-swagger'

gem 'mongoid', '4.0.0.beta1'

gem 'bundler'
gem 'rake'

gem 'json'

gem 'rack-cors'
gem 'rack-oauth2'

gem 'gcm'

gem 'newrelic_rpm'
gem 'newrelic-grape'

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
  gem 'capistrano', '~> 3.2.0', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano3-puma', require: false
end

group :test do
  gem 'rspec'
  gem 'rspec-spies'
  gem 'json_spec'
  gem 'rack-test'
  gem 'fabrication'
  gem 'database_cleaner'
  gem 'simplecov'
  gem 'simplecov-teamcity-summary', github: 'balauru/simplecov-teamcity-summary'
  gem 'mongoid-rspec'
end
