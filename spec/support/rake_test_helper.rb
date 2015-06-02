module RakeTestHelper
  extend ActiveSupport::Concern

  included do
    include Rack::Test::Methods
  end

  def app
    OmniApi::App.instance
  end
end

RSpec.configure do |config|
  config.include RakeTestHelper, file_path: %r{spec\/api}
end
