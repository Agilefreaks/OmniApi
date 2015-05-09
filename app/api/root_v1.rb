module API
  # entities
  require 'entities/provider'
  require 'entities/user'
  require 'entities/device'
  require 'entities/clipping'
  require 'entities/authorization_code'
  require 'entities/sms_message'
  require 'entities/phone_call'
  require 'entities/contact'
  require 'entities/identity'

  # resources
  require 'resources/oauth2'
  require 'resources/version'
  require 'resources/user/contacts'
  require 'resources/user/devices'
  require 'resources/user/api'
  require 'resources/users/api'
  require 'resources/users/identities'
  require 'resources/clippings'
  require 'resources/authorization_codes'
  require 'resources/sms_messages'
  require 'resources/phone_calls'
  require 'resources/batch'

  class RootV1 < Grape::API
    mount Resources::OAuth2
    mount Resources::Version
    mount Resources::User::Api
    mount Resources::Users::Api
    mount Resources::Users::Identities
    mount Resources::Clippings
    mount Resources::AuthorizationCodes
    mount Resources::SmsMessages
    mount Resources::PhoneCalls
    mount Resources::Batch

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
