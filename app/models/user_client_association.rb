class UserClientAssociation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :scopes, type: Array

  belongs_to :user, index: true
  belongs_to :client, index: true

  embeds_one :access_token

  index({ 'access_token.token' => 1 }, unique: true, sparse: true)

  def self.find_by_client_id(client_id)
    find_by(client_id: client_id)
  end

  def self.find_by_token(token)
    where('access_token.refresh_token.token' => token).first unless token.nil?
  end
end
