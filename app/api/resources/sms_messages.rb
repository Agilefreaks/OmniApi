module API
  module Resources
    class SmsMessages < Grape::API
      resources :sms_messages do
        before do
          authenticate!
        end

        after do
          track
        end

        desc 'Create an sms message', ParamsHelper.omni_headers
        params do
          optional :phone_number, type: String, desc: 'The phone number to dial.'
          optional :phone_number_list, type: Array[String], desc: 'The phone number to dial.'
          mutually_exclusive :phone_number, :phone_number_list

          optional :content, type: String, desc: 'The content of the sms.'
          optional :content_list, type: Array[String], desc: 'The content of the sms.'
          mutually_exclusive :content, :content_list
        end
        post do
          SendSmsMessage.with(merged_params(false))
          body(false)
        end

        desc 'Get sms', ParamsHelper.omni_headers
        params do
          requires :id, type: String, desc: 'Sms Message id.'
        end
        route_param :id do
          get do
            present @current_user.sms_messages.find(declared_params[:id]), with: API::Entities::SmsMessage
          end
        end
      end
    end
  end
end
