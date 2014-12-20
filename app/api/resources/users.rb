module API
  module Resources
    class Users < Grape::API
      resource :users do
        helpers do
          def check_access_token(user)
            access_token =  user.access_tokens.where(client_id: @current_client.id).first ||
                            GenerateOauthToken.build_access_token_for(user, @current_client.id)
            access_token.touch
          end

          def fetch_user_with_email(email)
            authenticate_client!

            users = User.where(email: email)
            users.each do |user|
              check_access_token(user)
            end

            users
          end

          def fetch_user
            authenticate!
            @current_user
          end
        end

        desc 'Fetch a user.', ParamsHelper.omni_headers
        params do
          optional :email, type: String, desc: 'The Email of the user.'
        end
        get do
          result = declared_params[:email].to_s.empty? ? fetch_user : fetch_user_with_email(declared_params[:email])

          present result, with: API::Entities::User
        end

        desc 'Create a new user.', ParamsHelper.omni_headers
        params do
          requires :email, type: String, desc: 'The Email of the user.'
          optional :first_name, type: String
          optional :last_name, type: String
          optional :image_url, type: String, desc: 'The users image url'
        end
        post do
          authenticate_client!
          present UserBuilder.new.build(@current_client, declared_params), with: API::Entities::User
        end

        desc 'Update a existing user.', ParamsHelper.omni_headers
        params do
          requires :email, type: String, desc: 'The Email of the user.'
          optional :first_name, type: String
          optional :last_name, type: String
          optional :image_url, type: String, desc: 'The users image url'
        end
        put do
          authenticate_client!

          user = User.find_by(email: declared_params[:email])
          user.update(declared_params)
          check_access_token(user)

          present user, with: API::Entities::User
        end

        resources :contacts do
          before do
            authenticate!
          end

          desc 'Get all contacts.', ParamsHelper.omni_headers
          params do
            requires :identifier, type: String, desc: 'The device identifier that requires the contacts.'
          end
          get do
            present FindContactList.for(merged_params), with: Entities::ContactList
          end

          desc 'Post a list of contacts.', ParamsHelper.omni_headers
          params do
            requires :source_identifier, type: String, desc: 'The device that sourced the contacts.'
            requires :identifier, type: String, desc: 'The device identifier that requires the contacts.'
            requires :contacts, type: String, desc: 'The contacts array encoded.'
          end
          post do
            CreateContactList.with(merged_params)
          end
        end
      end
    end
  end
end
