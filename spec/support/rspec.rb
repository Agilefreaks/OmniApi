RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
end

RSpec::Matchers.define :be_the_same_time_as do |expected|
  match do |actual|
    expected.to_i == actual.to_i
  end
end
