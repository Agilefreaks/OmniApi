OmniKiq.configure do |config|
  settings = YAML.load_file(File.expand_path('../../omnikiq.yml', __FILE__))[ENV['RACK_ENV']]
  if settings.present?
    config.redis_namespace = settings['redis_namespace']
    config.redis_url = settings['redis_url']
  end
end
