require_relative 'concerns/oauth2_user'
require_relative 'concerns/oauth2_finders'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::OAuth2User
  include Concerns::OAuth2Finders

  field :first_name, type: String
  field :last_name, type: String

  field :email, type: String, default: ''

  validates_uniqueness_of :email

  embeds_many :registered_devices
  accepts_nested_attributes_for :registered_devices

  embeds_many :providers
  accepts_nested_attributes_for :providers

  has_many :clippings
  has_many :events

  index({ :'registered_devices.identifier' => 1 }, { unique: true, drop_dups: true, sparse: true })
  index(:'registered_devices.registration_id' => 1)

  def active_registered_devices
    registered_devices.active
  end

  def self.find_by_provider_or_email(email, provider)
    User.where('providers.email' => email, 'providers.name' => provider)
  end
end
