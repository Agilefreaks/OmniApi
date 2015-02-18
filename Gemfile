source 'http://rubygems.org'
ruby '2.2.0'

gem 'puma'

gem 'grape', '~> 0.10.1'
gem 'grape-entity'
gem 'grape-swagger'
gem 'grape-batch'

gem 'mongoid', '~> 4.0'

gem 'bundler'
gem 'rake'

gem 'json'

gem 'rack-cors', require: 'rack/cors'
gem 'rack-oauth2'

gem 'gcm'

gem 'newrelic_rpm'
gem 'newrelic-grape'

gem 'omnikiq'

gem 'sometimes'

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
  gem 'database_cleaner', '1.3.0'
  gem 'simplecov'
  gem 'simplecov-teamcity-summary'
  gem 'mongoid-rspec', '~> 2.0.0.rc1'
  gem 'timecop'
  gem 'faker'
end
