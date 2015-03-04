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
     sms_message_received send_sms_message_requested sms_message_delivered
     contacts_updated contact_updated contact_created).each do |method_name|
    define_method(method_name) do |model, device_id|
      options = {
        data:
          {
            type: method_name
          }
      }

      options[:data][:payload] = { id: model.id.to_s } if model.respond_to?(:id)

      send_notification(model.user, device_id, options)
    end
  end

  private

  def send_notification(user, source_device_id, options)
    devices_to_notify = filtered_active_devices(user, source_device_id)

    grouped_providers = {}
    devices_to_notify.each do |device|
      grouped_providers[device.provider] ||= []
      grouped_providers[device.provider].append(device.registration_id)
    end

    grouped_providers.each do |key, values|
      @providers[key].send_notification(values, options)
    end
  end

  def filtered_active_devices(user, source_device_id)
    if BSON::ObjectId.legal?(source_device_id)
      user.active_devices.where(:_id.ne => BSON::ObjectId.from_string(source_device_id))
    else
      user.active_devices
    end
  end
end
