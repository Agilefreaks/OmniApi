class ContactList
  include Mongoid::Document
  include Mongoid::Timestamps

  EMPTY = :empty

  field :device_identifier, type: String
  field :contacts, type: String

  embedded_in :user

  validates_presence_of :device_identifier
end
