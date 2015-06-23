class UserClientAssociation
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, index: true
  belongs_to :client, index: true

  embeds_many :scopes
end
