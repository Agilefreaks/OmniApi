module API
  module Resources
    module User
      class Api < Grape::API
        resource :user do
          mount API::Resources::User::Contacts

          mount API::Resources::User::Devices
        end
      end
    end
  end
end
