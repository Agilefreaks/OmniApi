require 'database_cleaner'

RSpec.configure do |config|
  config.include Mongoid::Matchers

  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end