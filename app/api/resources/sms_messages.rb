module API
  module Resources
    class SmsMessages < Grape::API
      resources :sms_messages do
        before do
          authenticate!
        end

        after do
          track_sms_messages(declared_params)
        end

        helpers do
          params :shared do
            optional :device_id,
                     type: String,
                     desc: 'Device id. Can be the source device id orr
                            the target device id, depending on the value of @state'

            optional :phone_number, type: String, desc: 'The phone number to dial.'
            optional :phone_number_list, type: Array[String], desc: 'The phone number to dial.'
            mutually_exclusive :phone_number, :phone_number_list

            optional :content, type: String, desc: 'The content of the sms.'
            optional :content_list, type: Array[String], desc: 'The content of the sms.'
            mutually_exclusive :content, :content_list

            optional :contact_name, type: String, desc: 'The contact name.'
            optional :contact_id, type: Integer, desc: 'The contact id.'
            optional :contact_name_list, type: Array[String], desc: 'The contact names.'
            mutually_exclusive :contact_name, :contact_name_list

            requires :type,
                     values: %w(incoming outgoing),
                     type: String,
                     desc: 'Type of the sms_message.'
            requires :state,
                     values: %w(sending sent received),
                     type: String,
                     desc: 'State of the call.'
          end
        end

        desc 'Create an sms message', ParamsHelper.omni_headers
        params do
          use :shared
        end
        post do
          present Sms::Create.with(merged_params(false)), with: API::Entities::SmsMessage
        end

        route_param :id do
          desc 'Get sms', ParamsHelper.omni_headers
          params do
            requires :id, type: String, desc: 'Sms Message id.'
          end
          get do
            present @current_user.sms_messages.find(declared_params[:id]), with: API::Entities::SmsMessage
          end

          desc 'Patch sms', ParamsHelper.omni_headers
          params do
            use :shared
            requires :id, type: String, desc: 'Sms Message id.'
          end
          patch do
            present Sms::Update.with(merged_params(false)), with: API::Entities::SmsMessage
          end
        end
      end
    end
  end
end
