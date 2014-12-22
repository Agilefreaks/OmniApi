class Register
  class RegisterParams
    attr_reader :token, :identifier, :name, :client_version, :public_key

    def initialize(params)
      @token = params[:access_token]
      @identifier = params[:identifier]
      @name = params[:name]
      @public_key = params[:public_key]
      @client_version = params[:client_version]
    end
  end

  def self.device(params)
    Register.new(RegisterParams.new(params)).execute
  end

  attr_reader :register_params

  def initialize(register_params)
    @register_params = register_params
  end

  def execute
    user = User.find_by_token(@register_params.token)

    registered_device = user.registered_devices.find_or_initialize_by(identifier: @register_params.identifier)
    registered_device.update_attributes(
      name: @register_params.name,
      public_key: @register_params.public_key,
      client_version: @register_params.client_version)
    user.registered_devices.push(registered_device) if registered_device.new_record?
    user.save

    registered_device
  end
end
