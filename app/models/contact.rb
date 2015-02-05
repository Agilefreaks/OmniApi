class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  field :contact_id, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :phone_numbers, type: Array, default: []
  field :image, type: String

  belongs_to :user

  validates_presence_of :contact_id
end
