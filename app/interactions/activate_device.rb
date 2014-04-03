class ActivateDevice
  def self.with(params)
    ActivateDevice.new(params[:access_token], params[:identifier], params[:registration_id]).execute
  end

  attr_reader :access_token, :identifier, :registration_id

  def initialize(access_token, identifier, registration_id)
    @access_token = access_token
    @identifier = identifier
    @registration_id = registration_id
  end

  def execute
    user = User.find_by_token(@access_token)

    registered_device = user.registered_devices.find_by(identifier: @identifier)
    registered_device.update_attribute(:registration_id, @registration_id)

    registered_device
  end
end
