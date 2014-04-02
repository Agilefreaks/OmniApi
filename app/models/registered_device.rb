class RegisteredDevice
  include Mongoid::Document
  include Mongoid::Timestamps

  scope :active, -> { where(:registration_id.ne => nil) }

  field :registration_id, type: String
  field :name, type: String
  field :identifier, type: String

  embedded_in :user

  validates_presence_of :identifier

  index({ identifier: 1 }, { unique: true })
  index(registration_id: 1)
end
