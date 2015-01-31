class NotificationService
  attr_accessor :providers

  def initialize
    @providers = {
      gcm: GCM.new(Configuration.google_api_key),
      omni_sync: OmniSync.new(Configuration.omni_sync_api_key)
    }
  end

  %w(clipping_created
     end_phone_call_requested phone_call_received start_phone_call_requested phone_call_ended
     sms_message_received send_sms_message_requested).each do |method_name|
    define_method(method_name) do |model, device_id|
      options = {
        data:
          {
            type: method_name,
            payload: {
              id: model.id.to_s
            }
          }
      }
      send_notification(model.user, device_id, options)
    end
  end

  private

  def send_notification(user, source_device_id, options)
    devices_to_notify = user.active_devices.where(:_id.ne => BSON::ObjectId.from_string(source_device_id))

    grouped_providers = {}
    devices_to_notify.each do |device|
      grouped_providers[device.provider] ||= []
      grouped_providers[device.provider].append(device.registration_id)
    end

    grouped_providers.each do |key, values|
      @providers[key].send_notification(values, options)
    end
  end
end
