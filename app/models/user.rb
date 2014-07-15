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

  embeds_many :clippings
  accepts_nested_attributes_for :clippings

  embeds_many :providers
  accepts_nested_attributes_for :providers

  embeds_many :events
  accepts_nested_attributes_for :events

  def active_registered_devices
    registered_devices.active
  end

  def self.find_by_provider_or_email(email, provider)
    User.where('providers.email' => email, 'providers.name' => provider)
  end
end
