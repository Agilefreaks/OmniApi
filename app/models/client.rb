require_relative 'concerns/oauth2_finders'

class Client
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::OAuth2Finders

  field :name, type: String
  field :url, type: String
  field :secret, type: String, default: -> { SecureRandom.base64(64) }

  embeds_many :access_tokens

  index 'access_tokens.token' => 1

  before_save do
    next if access_tokens.size > 0

    access_token = AccessToken.build
    access_token.expires_at = Time.now.utc + 1.year
    access_tokens.push(AccessToken.build)
  end

  def scopes
    access_tokens.last.scopes.map { |scope| Scope.new(key: scope, description: ScopesRepository.description(scope)) }
  end

  def self.verify(client_id)
    Client.where(id: client_id).first
  end
end
