module API
  module Resources
    class Users < Grape::API
      resource :users do
        before do
          authenticate_client!
        end

        helpers do
          def check_access_token(user)
            access_token =  user.access_tokens.where(client_id: @current_client.id).first ||
                            GenerateOauthToken.build_access_token_for(user, @current_client.id)
            access_token.touch
          end
        end

        desc 'Fetch a user.', ParamsHelper.omni_headers
        params do
          requires :email, type: String, desc: 'The Email of the user.'
        end
        get do
          users = User.where(email: declared_params[:email])
          users.each do |user|
            check_access_token(user)
          end

          present users, with: API::Entities::User
        end

        desc 'Create a new user.', ParamsHelper.omni_headers
        params do
          requires :email, type: String, desc: 'The Email of the user.'
          optional :first_name, type: String
          optional :last_name, type: String
        end
        post do
          present UserFactory.new.create(@current_client, declared_params), with: API::Entities::User
        end

        desc 'Update a existing user.', ParamsHelper.omni_headers
        params do
          requires :email, type: String, desc: 'The Email of the user.'
          optional :first_name, type: String
          optional :last_name, type: String
        end
        put do
          user = User.find_by(email: declared_params[:email])
          user.update(declared_params)
          check_access_token(user)

          present user, with: API::Entities::User
        end
      end
    end
  end
end
