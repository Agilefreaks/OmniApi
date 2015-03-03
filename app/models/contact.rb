class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  field :device_id, type: String
  field :contact_id, type: Integer
  field :first_name, type: String
  field :last_name, type: String
  field :name, type: String
  field :middle_name, type: String
  field :image, type: String

  belongs_to :user

  embeds_many :phone_numbers

  validates_presence_of :contact_id
  validates_uniqueness_of :contact_id
end
