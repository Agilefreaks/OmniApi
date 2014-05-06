class GetAuthorizationCode
  def self.for(user_id)
    GetAuthorizationCode.new(user_id).execute
  end

  attr_reader :user_access_token

  def initialize(user_access_token)
    @user_access_token = user_access_token
  end

  def execute
    user = User.find_by_token(@user_access_token)
    user.authorization_codes.first || user.authorization_codes.create
  end
end
