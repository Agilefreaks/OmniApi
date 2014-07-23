module API
  module Resources
    class AuthorizationCodes < Grape::API
      resource :authorization_codes do
        before do
          authenticate_client!
        end

        desc 'Create an authorization code.', ParamsHelper.auth_headers
        params do
          requires :user_access_token, type: String, desc: 'Identifies the user that will get a authorization code.'
        end
        post do
          AuthorizationService.verify(:authorization_codes, :create, @current_token)
          present GetAuthorizationCode.for(declared_params[:user_access_token]), with: API::Entities::AuthorizationCode
        end

        desc 'Get an authorization code', ParamsHelper.auth_headers
        params do
          requires :emails, type: Array, desc: 'A list of emails.'
        end
        get do
          AuthorizationService.verify(:authorization_codes, :get, @current_token)
          present GetAuthorizationCode.for_emails(declared_params[:emails]), with: API::Entities::AuthorizationCode
        end
      end
    end
  end
end
