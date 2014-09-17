class ActivateDevice
  class ActivateParams
    attr_reader :access_token, :identifier, :registration_id, :provider, :client_version

    def initialize(params)
      @access_token = params[:access_token]
      @identifier = params[:identifier]
      @registration_id = params[:registration_id]
      @provider = params[:provider] || :gcm
      @client_version = params[:client_version]
    end
  end

  def self.with(params)
    ActivateDevice.new(ActivateParams.new(params)).execute
  end

  attr_reader :activate_params

  def initialize(activate_params)
    @activate_params = activate_params
  end

  def execute
    user = User.find_by_token(@activate_params.access_token)

    registered_device = user.registered_devices.find_by(identifier: @activate_params.identifier)
    registered_device.update_attributes(
      registration_id: @activate_params.registration_id,
      provider: @activate_params.provider,
      client_version: @activate_params.client_version
    )

    registered_device
  end
end
