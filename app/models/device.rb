class Device
  include Mongoid::Document
  include Mongoid::Timestamps

  scope :active, -> { where(:registration_id.ne => nil) }

  field :name, type: String
  field :provider, type: Symbol
  field :registration_id, type: String
  field :client_version, type: String
  field :public_key, type: String

  embedded_in :user
end
