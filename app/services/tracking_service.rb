require 'mixpanel-ruby'

class TrackingService
  TRACKING_API_KEY = 'd4a302f695330322fe4c44bc302f3780'

  ACTIVATION_EVENT = 'Device activation'
  REGISTRATION_EVENT = 'Device registration'
  CALL_EVENT = 'Call'
  END_INCOMING_CALL_EVENT = 'End incoming call'
  SEND_SMS = 'Send SMS'
  NEW_CLIPPING = 'New clipping'
  GET_CLIPPING = 'Get clipping'
  NEW_EVENT = 'New event'
  GET_EVENT = 'Get event'
  WINDOWS = 'Windows'
  ANDROID = 'Android'
  DEVICE_TYPE = { gcm: ANDROID, omni_sync: WINDOWS }

  TRACKED_DEVICES = {
    put_devices_activate: ACTIVATION_EVENT,
    post_devices: REGISTRATION_EVENT,
    post_devices_call: CALL_EVENT,
    post_devices_end_call: END_INCOMING_CALL_EVENT
  }

  TRACKED_CLIPPINGS = {
    post_clippings: NEW_CLIPPING,
    get_clippings_last: GET_CLIPPING
  }

  TRACKED_EVENTS = {
    post_events: NEW_EVENT,
    get_events: GET_EVENT
  }

  def self.tracker
    @tracker ||= Mixpanel::Tracker.new(TRACKING_API_KEY)
  end

  def self.track_devices(email, event, params = {})
    tracker.track(email, TRACKED_DEVICES[event], params) unless TRACKED_DEVICES[event].nil?
  end

  def self.track_clippings(email, event, params = {})
    tracker.track(email, TRACKED_CLIPPINGS[event], params) unless TRACKED_CLIPPINGS[event].nil?
  end

  def self.track_events(email, event, params = {})
    tracker.track(email, TRACKED_EVENTS[event], params) unless TRACKED_EVENTS[event].nil?
  end
end
