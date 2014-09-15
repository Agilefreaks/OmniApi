class RegisteredDevice
  include Mongoid::Document
  include Mongoid::Timestamps

  scope :active, -> { where(:registration_id.ne => nil) }

  field :registration_id, type: String
  field :name, type: String
  field :identifier, type: String
  field :provider, type: Symbol

  embedded_in :user

  validates_presence_of :identifier
end
