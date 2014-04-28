class Configuration
  class << self
    attr_accessor :app_version
    attr_accessor :google_api_key
    attr_accessor :omni_sync_url
    attr_accessor :omni_sync_api_key
  end

  @app_version = '1.0.9'

  @google_api_key = 'AIzaSyDiX6YE0kjKmnjSygNRC_sYq6MBUfzsg2I'

  @omni_sync_url = 'http://localhost:9293'
  @omni_sync_api_key = '42'
end
