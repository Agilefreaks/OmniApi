require_relative 'concerns/oauth2_finders'

class Client
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::OAuth2Finders

  field :secret, type: String, default: -> { SecureRandom.base64(64) }
  field :name, type: String

  embeds_many :access_tokens

  index 'access_tokens.token' => 1

  before_save do
    next if access_tokens.size > 0

    access_token = AccessToken.build
    access_token.expires_at = Date.current + 1.year
    access_tokens.push(AccessToken.build)
  end

  def self.verify(client_id)
    Client.where(id: client_id).first
  end
end
