class GetAuthorizationCode
  def self.for(user_id)
    GetAuthorizationCode.new(user_id).execute
  end

  attr_reader :user_id

  def initialize(user_id)
    @user_id = user_id
  end

  def execute
    user = User.find(@user_id)
    user.authorization_codes.first || user.authorization_codes.create
  end
end
