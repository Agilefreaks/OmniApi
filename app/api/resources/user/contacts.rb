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
            present FindContactList.for(merged_params), with: Entities::ContactList
          end

          desc 'Post a list of contacts.', ParamsHelper.omni_headers
          params do
            requires :identifier, type: String, desc: 'The device that sourced the contacts.'
            requires :destination_identifier, type: String, desc: 'The device identifier that requires the contacts.'
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
