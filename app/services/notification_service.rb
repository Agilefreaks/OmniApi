class NotificationService
  attr_accessor :providers

  def initialize
    @providers = {
      gcm: GCM.new(Configuration.google_api_key),
      omni_sync: OmniSync.new(Configuration.omni_sync_api_key)
    }
  end

  def notify(model, source_identifier)
    send(model.class.to_s.underscore.to_sym, model, source_identifier)
  end

  def call(model, source_identifier)
    options = {
      data:
        {
          registration_id: 'other',
          phone_action: 'call', phone_number: model.content,
          provider: 'phone'
        }
    }
    send_notification(model.user, source_identifier, options)
  end

  def end_call(model, source_identifier)
    options = {
      data:
        {
          registration_id: 'other',
          phone_action: 'end_call',
          provider: 'phone'
        }
    }
    send_notification(model.user, source_identifier, options)
  end

  def sms(model, source_identifier)
    options = {
      data:
        {
          registration_id: 'other',
          phone_action: 'sms', phone_number: model.phone_number, sms_content: model.content,
          provider: 'phone'
        }
    }
    send_notification(model.user, source_identifier, options)
  end

  private

  def clipping(model, source_identifier)
    options = { data: { registration_id: 'other', provider: 'clipboard' } }
    send_notification(model.user, source_identifier, options)
  end

  def incoming_call_event(model, source_identifier)
    options = { data: { registration_id: 'other', provider: 'notification' } }
    send_notification(model.user, source_identifier, options)
  end

  def send_notification(user, source_identifier, options)
    devices_to_notify = user.active_registered_devices.where(:identifier.ne => source_identifier)

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
