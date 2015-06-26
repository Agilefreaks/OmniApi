class UserClientAssociation
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, index: true
  belongs_to :client, index: true

  embeds_one :access_token

  embeds_many :scopes

  index({ 'access_token.token' => 1 }, unique: true, sparse: true)

  def self.find_by_client_id(client_id)
    find_by(client_id: client_id)
  end
end
