class TrackingService
  ACTIVATION_EVENT = 'Device activation'
  DEACTIVATION_EVENT = 'Device deactivated'
  REGISTRATION_EVENT = 'Device registration'
  CALL_EVENT = 'Call'
  END_INCOMING_CALL_EVENT = 'End incoming call'
  SEND_SMS = 'Send SMS'
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

  TRACKED_EVENTS = {
    put_devices_activate: ACTIVATION_EVENT,
    put_devices_deactivate: DEACTIVATION_EVENT,
    post_devices: REGISTRATION_EVENT,
    post_devices_call: CALL_EVENT,
    post_devices_end_call: END_INCOMING_CALL_EVENT,
    post_devices_sms: SEND_SMS,
    post_clippings: NEW_CLIPPING,
    get_clippings_last: GET_CLIPPING,
    post_events: NEW_EVENT,
    get_events: GET_EVENT,
    post_userscontacts_contacts: POST_CONTACTS,
    get_userscontacts_contacts: GET_CONTACTS,
    post_sync: SYNC_REQUEST
  }

  def self.track(email, event, params = {})
    OmniKiq::Trackers::MixpanelEvents.perform_async(email,
                                                    TRACKED_EVENTS[event],
                                                    params) unless TRACKED_EVENTS[event].nil?
    OmniKiq::Trackers::MixpanelPeople.perform_async(email,
                                                    last_seen: DateTime.now)
  end
end
