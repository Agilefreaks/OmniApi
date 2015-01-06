class DeviceBuilder
  def build(token, params)
    user = User.find_by_token(token)
    user.devices.create(params)
  end
end
