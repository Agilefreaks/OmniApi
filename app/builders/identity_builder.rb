class IdentityBuilder
  attr_accessor :user_id

  def self.for(user_id)
    builder = IdentityBuilder.new
    builder.user_id = user_id

    builder
  end

  def build(params)
    user = User.find(user_id)
    user.identity = create_identity(params)
    user.save!

    user.identity
  end

  private

  def create_identity(params)
    identity = Identity.new
    identity.provider = params[:provider]
    identity.scope = params[:scope]
    identity.expires = params[:expires]
    identity.expires_at = params[:expires_at]
    identity.token = params[:token]
    identity.refresh_token = params[:refresh_token]

    identity
  end
end
