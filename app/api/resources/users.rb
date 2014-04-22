module API
  module Resources
    class Users < Grape::API
      before do
        # require_oauth_token
      end

      resource :users do
        params do
          requires :id, type: String, desc: 'The id of the user.'
        end
        route_param :id do
          get do
            present User.find(declared_params[:id]), with: API::Entities::User
          end
        end

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

        params do
          requires :email, type: String, desc: 'The Email of the user.'
          optional :first_name, type: String
          optional :last_name, type: String
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

        params do
          requires :id, type: String, desc: 'The id of the user.'
          optional :email, type: String, desc: 'The Email of the user.'
          optional :first_name, type: String
          optional :last_name, type: String
          optional :sign_in_count
          optional :current_sign_in_at
          optional :last_sign_in_at
          optional :current_sign_in_ip
          optional :last_sign_in_ip
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
