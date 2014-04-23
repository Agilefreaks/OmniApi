module API
  module Resources
    class Users < Grape::API
      resource :users do
        before do
          authenticate_client!
        end

        desc 'Fetch a user.', ParamsHelper.auth_headers
        params do
          requires :id, type: String, desc: 'The id of the user.'
        end
        route_param :id do
          get do
            present User.find(declared_params[:id]), with: API::Entities::User
          end
        end

        desc 'Fetch a users.', ParamsHelper.auth_headers
        params do
          optional :id, type: String, desc: 'The id of the user.'
          optional :email, type: String
          optional :provider_name, type: String
        end
        get do
          user = if declared_params[:id]
                   User.where(id: declared_params[:id])
                 else
                   email = declared_params[:email]
                   provider = declared_params[:provider_name]
                   User.find_by_provider_or_email(email, provider)
                 end

          present user, with: API::Entities::User
        end

        desc 'Create a new user.', ParamsHelper.auth_headers
        params do
          requires :email, type: String, desc: 'The Email of the user.'
          optional :first_name, type: String
          optional :last_name, type: String
          optional :image_url, type: String
          optional :providers, type: Array do
            requires :name
            requires :uid
            requires :auth
            requires :email
          end
        end
        post do
          present UserFactory.new.create(declared_params), with: API::Entities::User
        end

        desc 'Update and existing user.', ParamsHelper.auth_headers
        params do
          requires :id, type: String, desc: 'The id of the user.'
          optional :email, type: String, desc: 'The Email of the user.'
          optional :first_name, type: String
          optional :last_name, type: String
          optional :sign_in_count, type: String
          optional :current_sign_in_at, type: String
          optional :last_sign_in_at, type: String
          optional :current_sign_in_ip, type: String
          optional :last_sign_in_ip, type: String
        end
        route_param :id do
          put do
            user = User.find(declared_params[:id])
            user.update(declared_params)
            present user, with: API::Entities::User
          end
        end
      end
    end
  end
end
