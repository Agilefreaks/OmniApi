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
          present GetAuthorizationCode.for(declared_params[:user_access_token]), with: API::Entities::AuthorizationCode
        end
      end
    end
  end
end
