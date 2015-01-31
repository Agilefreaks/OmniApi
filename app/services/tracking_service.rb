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
  NEW_CLIPPING = 'New clipping'
  GET_CLIPPING = 'Get clipping'
  NEW_EVENT = 'New event'
  GET_EVENT = 'Get event'
  GET_CONTACTS = 'Get contacts'
  POST_CONTACTS = 'Send contacts'
  SYNC_REQUEST = 'Sync request'
  WINDOWS = 'Windows'
  ANDROID = 'Android'
  DEVICE_TYPE = { gcm: ANDROID, omni_sync: WINDOWS }

  UNKNOWN = 'unknown'

  TRACKED_EVENTS = {
    # devices
    post_userdevices_devices: REGISTRATION,
    patch_userdevices_activate: ACTIVATION,
    patch_userdevices_deactivate: DEACTIVATION,

    # phone_calls
    post_phone_calls: INCOMING_CALL,
    patch_phone_calls: END_INCOMING_CALL,

    # sms
    post_sms_messages: SEND_SMS,

    # clippings
    post_clippings: NEW_CLIPPING,
    get_clippings: GET_CLIPPING,

    # events: incoming_call, incoming_sms
    post_events: NEW_EVENT,
    get_events: GET_EVENT,

    # contacts sync
    post_userscontacts_contacts: POST_CONTACTS,
    get_userscontacts_contacts: GET_CONTACTS,
    post_sync: SYNC_REQUEST,

    # deprecated events
    post_devices: REGISTRATION,
    get_clippings_last: GET_CLIPPING,
    post_devices_end_call: END_INCOMING_CALL,
    post_devices_call: INCOMING_CALL,
    put_devices_activate: ACTIVATION,
    put_devices_deactivate: DEACTIVATION,
    post_devices_sms: SEND_SMS
  }

  def self.track(email, event, params = {})
    OmniKiq::Trackers::MixpanelEvents.perform_async(email, event, params)
    OmniKiq::Trackers::MixpanelPeople.perform_async(email, last_seen: DateTime.now)
  end
end
