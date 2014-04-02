class Unregister
  def self.device(params)
    Unregister.new(params[:access_token], params[:identifier]).execute
  end

  attr_accessor :access_token, :identifier

  def initialize(access_token, identifier)
    @access_token = access_token
    @identifier = identifier
  end

  def execute
    user = User.find_by_token(@access_token)
    device = user.registered_devices.find_by(identifier: @identifier)
    user.registered_devices.delete(device)
  end
end
