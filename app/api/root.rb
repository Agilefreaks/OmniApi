module API
  # entities
  require 'entities/user'
  require 'entities/registered_device_entity'

  # resources
  require 'resources/oauth2'
  require 'resources/version'
  require 'resources/users'
  require 'resources/devices'

  class Root < Grape::API
    version 'v1', using: :path, vendor: 'OmniApi', cascade: false
    prefix 'api'
    format :json

    rescue_from Mongoid::Errors::DocumentNotFound do
      rack_response({ error: { message: "We didn't find what we were looking for" } }.to_json, 404)
    end

    helpers do
      def require_oauth_token
        @current_token = request.env[Rack::OAuth2::Server::Resource::ACCESS_TOKEN]
        fail Rack::OAuth2::Server::Resource::Bearer::Unauthorized unless @current_token
      end

      def authenticate!
        require_oauth_token
        @current_user = User.find_by_token(@current_token.token)
        fail Rack::OAuth2::Server::Resource::Bearer::Unauthorized unless @current_user
      end
    end

    mount Resources::OAuth2
    mount Resources::Version
    mount Resources::Users
    mount Resources::Devices

    add_swagger_documentation(
      api_version: 'v1',
      mount_path: 'doc',
      hide_documentation_path: true,
      markdown: true
      )
  end
end
