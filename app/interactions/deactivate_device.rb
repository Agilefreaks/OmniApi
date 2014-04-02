class DeactivateDevice
  def self.with(params)
    DeactivateDevice.new(params[:access_token], params[:identifier]).execute
  end

  attr_reader :access_token, :identifier

  def initialize(access_token, identifier)
    @access_token = access_token
    @identifier = identifier
  end

  def execute
    user = User.find_by_token(access_token)

    registered_device = user.registered_devices.find_by(identifier: @identifier)
    registered_device.update_attribute(:registration_id, nil)

    registered_device
  end
end