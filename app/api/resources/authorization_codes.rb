module API
  module Resources
    class AuthorizationCodes < Grape::API
      resource :authorization_codes do
        before do
          authenticate_client!
        end

        params do
          requires :user_id, type: String, desc: 'Identifies the user that will get a authorization code.'
        end
        post do
          present GetAuthorizationCode.for(declared_params[:user_id]), with: API::Entities::AuthorizationCode
        end
      end
    end
  end
end
