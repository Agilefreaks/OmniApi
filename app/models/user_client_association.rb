class UserClientAssociation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :scopes, type: Array

  belongs_to :user, index: true
  belongs_to :client, index: true

  def self.find_by_client_id(client_id)
    find_by(client_id: client_id)
  end

  def access_token
    @access_token || (@access_token = user.access_tokens.where(client_id: client_id).last)
  end
end
