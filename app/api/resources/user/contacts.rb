module API
  module Resources
    module User
      class Contacts < Grape::API
        resources :contacts do
          before { authenticate! }

          def contact_headers
            {
              headers: ParamsHelper.auth_headers.merge(ParamsHelper.client_version_headers).merge('No-Notification' => {
                                                                                                    description: 'Set not to send sync.',
                                                                                                    required: false
                                                                                                  })
            }
          end

          desc 'Post a contact.', contact_headers
          params do
            optional :device_id, type: String, desc: 'Id for source device.'
            requires :contact_id, type: Integer, desc: 'A unique contact id used to identify a contact across devices.'
            optional :first_name, type: String, desc: 'The contact first name.'
            optional :last_name, type: String, desc: 'The contact last name.'
            optional :name, type: String, desc: 'The contact name.'
            optional :middle_name, type: String, desc: 'The contact middle name.'
            optional :phone_numbers, type: Array, desc: 'An array of phone numbers corresponding to the contact' do
              requires :number, type: String, desc: 'The actual phone number.'
              requires :type, type: String, desc: 'The type of the phone number.'
            end
            optional :image, type: String, desc: 'A Base64 encoded image'
          end
          post do
            contact = CreateContact.with(merged_params(false).merge(no_notification: headers['No-Notification']))

            if contact.valid?
              present contact, with: API::Entities::Contact
            else
              error!(contact.errors, 400)
            end
          end

          desc "Get a user's contacts", ParamsHelper.omni_headers
          params do
            optional :from, type: Time, desc: 'A timestamp in the iso8601 format (eg: 2015-02-06T15:03:30+02:00),
                                               to filter contacts with, based on their updated_at field'
          end
          get do
            present FindContacts.for(@current_token.token, declared_params[:from]), with: API::Entities::Contact
          end
        end
      end
    end
  end
end
