class Register
  def self.device(params)
    Register.new(params[:access_token], params[:identifier], params[:name]).execute
  end

  attr_accessor :token, :identifier, :name

  def initialize(token, identifier, name)
    @token = token
    @identifier = identifier
    @name = name
  end

  def execute
    user = User.find_by_token(@token)

    registered_device = user.registered_devices.find_or_initialize_by(identifier: @identifier)
    new_record = registered_device.new_record?
    registered_device.name = name
    user.registered_devices.push(registered_device) if registered_device.new_record?
    user.save

    registered_device.just_created = new_record

    registered_device
  end
end
