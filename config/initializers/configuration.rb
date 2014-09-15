class Configuration
  class << self
    attr_accessor :app_version
    attr_accessor :google_api_key
    attr_accessor :omni_sync_url
    attr_accessor :omni_sync_api_key
  end

  @app_version = '1.2.10'

  @google_api_key = 'AIzaSyDiX6YE0kjKmnjSygNRC_sYq6MBUfzsg2I'

  @omni_sync_url = case ENV['RACK_ENV']
                   when 'development'
                     'http://localhost:9293'
                   when 'staging'
                     'https://syncstaging.omnipasteapp.com'
                   else
                     'https://sync.omnipasteapp.com'
                   end
  @omni_sync_api_key = '42'
end
