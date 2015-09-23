module API
  module Resources
    class OAuth2 < Grape::API
      helpers do
        def authorization_response(env)
          GenerateOauthToken.for(env)
        end
      end

      namespace :oauth2 do
        params do
          requires :grant_type,
                   type: Symbol,
                   values: [:authorization_code, :refresh_token, :client_credentials],
                   desc: 'The grant type.'
          requires :client_id,
                   type: String,
                   desc: 'The client id.'
          optional :code,
                   type: String,
                   desc: 'The authorization code.'
          optional :refresh_token,
                   type: String,
                   desc: 'The refresh_token.'
          optional :client_secret,
                   type: String,
                   desc: 'The client secret.'
          optional :resource_type,
                   type: Symbol,
                   values: [:user, :client, :user_client_association],
                   desc: 'The type of the resource for which to create the access token'
          optional :resource_id,
                   type: String,
                   desc: 'The identifier of resource for which to create the access token. eg: the email for a user'
        end
        post :token do
          response = authorization_response(env)

          # status
          status response[0]

          # headers
          response[1].each do |key, value|
            header key, value
          end

          # body
          body JSON.parse(response[2].body.first)
        end
      end
    end
  end
end
