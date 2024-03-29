require_relative 'concerns/oauth2_token'

class AccessToken
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::OAuth2Token

  field :scopes, type: Array

  embedded_in :client
  embedded_in :user
  embeds_one :refresh_token

  def self.verify(token)
    access_token = AccessToken.new(token: token)
    access_token if access_token.valid?
  end

  def to_bearer_token(with_refresh_token = false)
    bearer_token = Rack::OAuth2::AccessToken::Bearer.new(
      access_token: token,
      expires_in: (expires_at - Time.now.utc).to_i
    )

    bearer_token.refresh_token = refresh_token.token if with_refresh_token

    bearer_token
  end
end
