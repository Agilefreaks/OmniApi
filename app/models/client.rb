class Client
  include Mongoid::Document
  include Mongoid::Timestamps

  field :secret, type: String, default: -> { SecureRandom.base64(64) }

  embeds_many :access_tokens

  index({ 'access_token.token' => 1 }, { unique: true })

  def self.verify(client_id)
    Client.where(id: client_id).first
  end
end
