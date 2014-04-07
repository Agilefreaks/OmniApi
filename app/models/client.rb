class Client
  include Mongoid::Document
  include Mongoid::Timestamps

  field :secret, type: String, default: -> { SecureRandom.base64(64) }
  field :name, type: String

  embeds_many :access_tokens

  index 'access_tokens.token' => 1

  before_create do
    access_tokens.push(AccessToken.build)
  end

  def self.verify(client_id)
    Client.where(id: client_id).first
  end
end
