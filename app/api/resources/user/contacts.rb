module API
  module Resources
    module User
      class Contacts < Grape::API
        resources :contacts do
          before do
            authenticate!
          end

          desc 'Get all contacts.', ParamsHelper.omni_headers
          params do
            requires :identifier, type: String, desc: 'The device identifier that requires the contacts.'
          end
          get do
          end

          desc 'Post a list of contacts.', ParamsHelper.omni_headers
          params do
            requires :identifier, type: String, desc: 'The device that sourced the contacts.'
            requires :destination_identifier, type: String, desc: 'The device identifier that requires the contacts.'
            requires :contacts, type: String, desc: 'The contacts array encoded.'
          end
          post do
          end
        end
      end
    end
  end
end
