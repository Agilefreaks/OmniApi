module API
  module Resources
    class ScheduledSmsMessages < Grape::API
      resources :scheduled_sms_messages do
        before do
          authenticate_client!
        end

        route_param :id do
          desc 'To send a scheduled sms, body should contain "state" = "sending"', ParamsHelper.omni_headers
          params do
            optional :device_id,
                     type: String,
                     desc: 'Device id. Can be the source device id orr
                                the target device id, depending on the value of @state'
            requires :state,
                     values: %w(sending sent received scheduled),
                     type: String,
                     desc: 'State of the message.'
            requires :id, type: String, desc: 'Sms Message id.'
          end
          patch do
            present Sms::Send.with(merged_params), with: API::Entities::SmsMessage
          end
        end
      end
    end
  end
end
