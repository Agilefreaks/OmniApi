module API
  # entities
  require 'entities/provider'
  require 'entities/user'
  require 'entities/registered_device'
  require 'entities/device'
  require 'entities/clipping'
  require 'entities/authorization_code'
  require 'entities/incoming_call_event'
  require 'entities/incoming_sms_event'
  require 'entities/contact_list'
  require 'entities/sms_message'

  # resources
  require 'resources/oauth2'
  require 'resources/version'
  require 'resources/users/api'
  require 'resources/devices'
  require 'resources/clippings'
  require 'resources/authorization_codes'
  require 'resources/events'
  require 'resources/sync'
  require 'resources/sms_messages'

  class RootV1 < Grape::API
    mount Resources::OAuth2
    mount Resources::Version
    mount Resources::Devices
    mount Resources::Users::Api
    mount Resources::Clippings
    mount Resources::AuthorizationCodes
    mount Resources::Events
    mount Resources::Sync
    mount Resources::SmsMessages

    base_paths = {
      'development' => 'http://localhost:9292/api/v1',
      'staging' => 'https://apistaging.omnipasteapp.com/api/v1'
    }

    add_swagger_documentation(
      api_version: 'v1',
      mount_path: 'doc',
      hide_documentation_path: true,
      base_path: base_paths[ENV['RACK_ENV']]
    )
  end
end
