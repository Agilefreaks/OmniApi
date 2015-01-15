module API
  module Resources
    module User
      class Api < Grape::API
        resource :user do
          desc 'Fetch user.', ParamsHelper.omni_headers
          get do
            authenticate!
            present @current_user, with: API::Entities::User
          end

          mount API::Resources::User::Contacts

          mount API::Resources::User::Devices
        end
      end
    end
  end
end
