#!/usr/bin/env rake
require 'rubygems'
require 'bundler'

ENV['RACK_ENV'] ||= 'development'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'rake'

task :environment do
  require File.expand_path('../config/environment', __FILE__)
end

task routes: :environment do
  API.routes.each do |route|
    pp route
  end
end

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'test'
  require 'rspec/core'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |spec|
    # do not run integration tests, doesn't work on TravisCI
    spec.pattern = FileList['spec/app/*_spec.rb']
  end

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)

  task default: [:rubocop, :spec]
end

load 'mongoid/tasks/database.rake'

# Load all rake tasks
Dir[File.expand_path(File.join('../lib/tasks/*.rake'), __FILE__)].each { |f| load f }

