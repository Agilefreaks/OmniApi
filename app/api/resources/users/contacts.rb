module API
  module Resources
    module Users
      class Contacts < Grape::API
        resources :contacts do
          before do
            authenticate!
          end

          after do
            params =
              {
                email: @current_user.email,
                identifier: merged_params[:identifier]
              }
            TrackingService.track(@current_user.email, TrackHelper.method_name(routes).to_sym, params)
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
