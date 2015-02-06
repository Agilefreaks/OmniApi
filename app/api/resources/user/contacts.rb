module API
  module Resources
    module User
      class Contacts < Grape::API
        resources :contacts do
          before { authenticate! }

          desc 'Post a contact.', ParamsHelper.omni_headers
          params do
            requires :contact_id, type: String, desc: 'A unique contact id used to identify a contact across devices.'
            requires :first_name, type: String, desc: 'The contact first name.'
            requires :last_name, type: String, desc: 'The contact last name.'
            requires :phone_numbers, type: Array, desc: 'An array of phone numbers corresponding to the contact'
            requires :image, type: String, desc: 'A Base64 encoded image'
          end
          post do
            present CreateContact.with(merged_params(false)), with: API::Entities::Contact
          end
        end
      end
    end
  end
end
