class TrackingService
  # devices
  ACTIVATION = 'Device activation'
  DEACTIVATION = 'Device deactivated'
  REGISTRATION = 'Device registration'

  # phone_calls
  INCOMING_CALL = 'Incoming Call'
  OUTGOING_CALL = 'Outgoing Call'
  END_INCOMING_CALL = 'End incoming call'
  GET_CALL = 'Get call'

  # sms
  RECEIVED_SMS = 'Received sms'
  OUTGOING_SMS = 'Outgoing sms'
  SEND_SMS = 'Send SMS'
  GET_SMS = 'Get SMS'

  # clippings
  CLIPPING = 'New clipping'
  GET_CLIPPING = 'Get clipping'

  WINDOWS = 'Windows'
  ANDROID = 'Android'
  DEVICE_TYPE = { gcm: ANDROID, omni_sync: WINDOWS }

  UNKNOWN = 'unknown'

  def self.event(email, event, params = {})
    return if event == TrackingService::UNKNOWN

    OmniKiq::Trackers::MixpanelEvents.perform_async(email, event, params)
    people(email, '$last_seen' => DateTime.now)
  end

  def self.people(email, params = {})
    OmniKiq::Trackers::MixpanelPeople.perform_async(email, params)
  end
end
