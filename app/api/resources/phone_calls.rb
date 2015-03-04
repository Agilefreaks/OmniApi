module API
  module Resources
    class PhoneCalls < Grape::API
      resources :phone_calls do
        before do
          authenticate!
        end

        after do
          track_phone_calls(declared_params)
        end

        helpers do
          params :shared do
            optional :device_id,
                     type: String,
                     desc: 'Device id. Can be the source device id or
                            the target device id, depending on the value of @state'
            optional :number, type: String, desc: 'The phone number.'
            optional :contact_name, type: String, desc: 'Contact name.'
            optional :contact_id, type: Integer, desc: 'Contact id.'
            optional :type,
                     values: %w(incoming outgoing),
                     type: String,
                     desc: 'Type of the call,'
            optional :state,
                     values: %w(starting started ended ending),
                     type: String,
                     desc: 'State of the call.'
          end
        end

        desc 'Create a phone call.', ParamsHelper.omni_headers
        params do
          use :shared
        end
        post do
          present Call::Create.with(merged_params), with: API::Entities::PhoneCall
        end

        route_param :id do
          desc 'Patch a call.', ParamsHelper.omni_headers
          params do
            requires :id, type: String, desc: 'The phone call id.'
            use :shared
          end
          patch do
            present Call::Update.with(merged_params(false)), with: API::Entities::PhoneCall
          end

          desc 'Get a phone call.', ParamsHelper.omni_headers
          params do
            requires :id, type: String, desc: 'The phone call id.'
          end
          get do
            present @current_user.phone_calls.find(declared_params[:id]), with: API::Entities::PhoneCall
          end
        end
      end
    end
  end
end
