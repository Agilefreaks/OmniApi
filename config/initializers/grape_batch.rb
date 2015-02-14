Grape::Batch.configure do |config|
  config.limit = 10
  config.path = '/api/v1/batch'
  config.formatter = Grape::Batch::Response
end
