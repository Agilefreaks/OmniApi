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
  EVENT = 'New event'
  GET_EVENT = 'Get event'
  WINDOWS = 'Windows'
  ANDROID = 'Android'
  DEVICE_TYPE = { gcm: ANDROID, omni_sync: WINDOWS }

  def self.tracker
    @tracker ||= Mixpanel::Tracker.new(TRACKING_API_KEY)
  end

  def self.track(email, event, params = {})
    tracker.track(email, event, params)
  end

  def self.put_devices_activate(args = {})
    email = args[:email]
    params = args[:params]
    track(email, ACTIVATION_EVENT, device_type: DEVICE_TYPE[params[:provider]], identifier: params[:identifier])
  end

  def self.post_devices(args = {})
    email = args[:email]
    params = args[:params]
    track(email, REGISTRATION_EVENT, identifier: params[:identifier])
  end

  def self.post_devices_call(args = {})
    track(args[:email], CALL_EVENT)
  end

  def self.post_devices_end_call(args = {})
    track(args[:email], END_INCOMING_CALL_EVENT)
  end

  def self.post_devices_sms(args = {})
    track(args[:email], SEND_SMS)
  end

  def self.post_clippings(args = {})
    track(args[:email], NEW_CLIPPING)
  end

  def self.get_clippings_last(args = {})
    track(args[:email], GET_CLIPPING)
  end

  def self.post_events(args = {})
    track(args[:email], EVENT, device_identifier: args[:identifier], type: args[:type])
  end

  def self.get_events(args = {})
    track(args[:email], GET_EVENT)
  end
end
