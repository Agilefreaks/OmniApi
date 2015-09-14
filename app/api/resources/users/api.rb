module API
  module Resources
    module Users
      class Api < Grape::API
        resources :users do
          helpers do
            def check_access_token(user, client)
              access_token =  user.access_tokens.for_client(client.id).first ||
                              GenerateOauthToken.build_access_token_for(user, client.id)
              req = OpenStruct.new(refresh_token: access_token.refresh_token.token)
              GenerateOauthToken::RefreshToken.create(nil, req) if access_token.expired?
            end

            def fetch_user_with_email(email)
              authenticate_client!

              users = ::User.where(email: email)
              users.each do |user|
                check_access_token(user, @current_client)
              end

              users
            end

            def fetch_user
              authenticate!
              @current_user
            end

            params :shared do
              requires :email, type: String, desc: 'The Email of the user.'
              optional :first_name, type: String
              optional :last_name, type: String
              optional :image_url, type: String, desc: 'The users image url'
            end
          end

          desc 'Fetch a user.', ParamsHelper.omni_headers
          params { optional :email, type: String, desc: 'The Email of the user.' }
          get do
            result = declared_params[:email].to_s.empty? ? fetch_user : fetch_user_with_email(declared_params[:email])
            present result
          end

          desc 'Create a new user.', ParamsHelper.omni_headers
          params { use :shared }
          post do
            authenticate_client!
            present UserBuilder.new.build(declared_params)
          end

          desc 'Update a existing user.', ParamsHelper.omni_headers
          params { use :shared }
          put do
            authenticate_client!

            user = ::User.find_by(email: declared_params[:email])
            user.update(declared_params)
            check_access_token(user, @current_client)

            present user
          end
        end
      end
    end
  end
end
