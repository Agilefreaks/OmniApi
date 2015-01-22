require 'mixpanel-ruby'

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
    # devices
    post_userdevices_devices: REGISTRATION_EVENT,
    patch_userdevices_activate: ACTIVATION_EVENT,
    patch_userdevices_deactivate: DEACTIVATION_EVENT,

    # phone_calls
    post_phone_calls: CALL_EVENT,
    patch_phone_calls: END_INCOMING_CALL_EVENT,

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
    post_devices: REGISTRATION_EVENT,
    get_clippings_last: GET_CLIPPING,
    post_devices_end_call: END_INCOMING_CALL_EVENT,
    post_devices_call: CALL_EVENT,
    put_devices_activate: ACTIVATION_EVENT,
    put_devices_deactivate: DEACTIVATION_EVENT,
    post_devices_sms: SEND_SMS
  }

  class NullObject
    def method_missing(*_args, &_block)
      self
    end
  end

  def self.tracker
    @tracker = if TrackConfig.test_mode
                 NullObject.new
               else
                 Mixpanel::Tracker.new(TrackConfig.api_key)
               end
  end

  def self.track(email, event, params = {})
    tracker.track(email, TRACKED_EVENTS[event], params) unless TRACKED_EVENTS[event].nil?
  end
end
