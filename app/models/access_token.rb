require_relative 'concerns/oauth2_token'

class AccessToken
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::OAuth2Token

  field :client_id, type: BSON::ObjectId

  embedded_in :client
  embedded_in :user
  embeds_one :refresh_tokens

  def to_bearer_token(with_refresh_token = false)
    bearer_token = Rack::OAuth2::AccessToken::Bearer.new(
      access_token: token,
      expires_in: expires_in
    )

    bearer_token.refresh_token = RefreshToken.build.token if with_refresh_token

    bearer_token
  end
end
