class NotificationService
  attr_accessor :providers

  def initialize
    @providers = {
      gcm: GCM.new(Configuration.google_api_key),
      omni_sync: OmniSync.new(Configuration.omni_sync_api_key)
    }
  end

  def notify(model, source_device_id)
    send(model.class.to_s.underscore.to_sym, model, source_device_id)
  end

  def call(model, source_device_id)
    options = {
      data:
        {
          registration_id: 'other',
          phone_action: 'call', phone_number: model.number,
          provider: 'phone'
        }
    }
    send_notification(model.user, source_device_id, options)
  end

  def end_call(model, source_device_id)
    options = {
      data:
        {
          registration_id: 'other',
          phone_action: 'end_call',
          provider: 'phone'
        }
    }
    send_notification(model.user, source_device_id, options)
  end

  def incoming_sms_message(model, source_device_id)
    options = {
      data:
        {
          type: 'sms_message',
          id: model.id.to_s,
          state: 'incoming'
        }
    }
    send_notification(model.user, source_device_id, options)
  end

  private

  def phone_call(model, device_id)
    options = {
      data:
        {
          type: 'phone_call',
          id: model.id.to_s,
          state: model.state
        }
    }
    send_notification(model.user, device_id, options)
  end

  def clipping(model, source_device_id)
    options = { data: { registration_id: 'other', provider: 'clipboard', id: model.id.to_s } }
    send_notification(model.user, source_device_id, options)
  end

  def incoming_call_event(model, source_device_id)
    options = { data: { registration_id: 'other', provider: 'notification' } }
    send_notification(model.user, source_device_id, options)
  end

  def incoming_sms_event(model, source_device_id)
    options = { data: { registration_id: 'other', provider: 'notification' } }
    send_notification(model.user, source_device_id, options)
  end

  def contact_list(model, source_device_id)
    options = { data: { registration_id: 'other', provider: 'contacts', identifier: model.identifier } }
    send_notification(model.user, source_device_id, options)
  end

  def send_notification(user, source_device_id, options)
    devices_to_notify = user.active_registered_devices.where(:identifier.ne => source_device_id)
    devices_to_notify += filtered_active_devices(user, source_device_id)

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
