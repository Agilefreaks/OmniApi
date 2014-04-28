class ActivateDevice
  def self.with(params)
    ActivateDevice.new(params[:access_token], params[:identifier], params[:registration_id], params[:provider] || :gcm).execute
  end

  attr_reader :access_token, :identifier, :registration_id, :provider

  def initialize(access_token, identifier, registration_id, provider)
    @access_token = access_token
    @identifier = identifier
    @registration_id = registration_id
    @provider = provider
  end

  def execute
    user = User.find_by_token(@access_token)

    registered_device = user.registered_devices.find_by(identifier: @identifier)
    registered_device.update_attributes({ registration_id: @registration_id, provider: @provider })

    registered_device
  end
end
