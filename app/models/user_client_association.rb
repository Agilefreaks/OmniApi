class UserClientAssociation
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, index: true
  belongs_to :client, index: true

  embeds_many :scopes

  def self.find_by_client_id(client_id)
    find_by(client_id: client_id)
  end
end
