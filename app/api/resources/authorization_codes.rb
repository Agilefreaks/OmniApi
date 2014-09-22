module API
  module Resources
    class AuthorizationCodes < Grape::API
      resource :authorization_codes do
        before do
          authenticate_client!
        end

        desc 'Create an authorization code.', ParamsHelper.omni_headers
        params do
          requires :email, type: String, desc: 'Identifies the user that will get a authorization code.'
        end
        post do
          AuthorizationService.verify(:authorization_codes, :create, @current_token)
          present GetAuthorizationCode.for(declared_params[:email]), with: API::Entities::AuthorizationCode
        end

        desc 'Get an authorization code', ParamsHelper.omni_headers
        params do
          requires :emails, type: Array, desc: 'A list of emails.'
        end
        get do
          AuthorizationService.verify(:authorization_codes, :get, @current_token)

          authorization_code_for_emails = GetAuthorizationCode.for_emails(declared_params[:emails])
          error!('No authorization code found', 404) if authorization_code_for_emails.is_a?(EmptyAuthorizationCode)

          present authorization_code_for_emails, with: API::Entities::AuthorizationCode
        end
      end
    end
  end
end
