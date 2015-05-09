module API
  module Resources
    module Users
      class Identities < Grape::API
        namespace :users do
          route_param :user_id do
            resources :identities do
              desc 'Create a new identity.', ParamsHelper.omni_headers
              params do
                requires :provider, type: String, description: 'Identity provider'
                requires :scope,
                         type: String,
                         description: 'Comma separated values representing access rights on the provider API'
                requires :expires, type: Boolean, description: 'Specifies if the identity expires'
                requires :expires_at,
                         type: DateTime,
                         description: 'The time until the token is valid.
                                       After it expired, you should use refresh_token to request a new acces token'
                requires :token, type: String, description: 'Token to use on request to the provider API'
                requires :refresh_token,
                         type: String,
                         description: 'Use this refresh_token to issue a new access token from
                                       the identity provider after the current one expired'
              end
              post do
                authenticate_client!
                identity = IdentityBuilder.for(params[:user_id]).build(params)

                present identity, with: API::Entities::Identity
              end
            end
          end
        end
      end
    end
  end
end
