require_relative 'concerns/oauth2_user'
require_relative 'concerns/oauth2_finders'
require_relative 'concerns/sometimes'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::OAuth2User
  include Concerns::OAuth2Finders
  include Concerns::Sometimes

  field :first_name, type: String
  field :last_name, type: String
  field :image_url, type: String
  field :email, type: String, default: ''
  field :mixpanel_profile_updated, type: Boolean, default: false
  field :contacts_updated_at, type: Time
  field :plan, type: Symbol, default: :basic

  validates_uniqueness_of :email

  embeds_many :devices
  accepts_nested_attributes_for :devices

  embeds_many :providers
  accepts_nested_attributes_for :providers


  has_many :clippings
  has_many :sms_messages
  has_many :phone_calls
  has_many :contacts

  def active_devices
    devices.active
  end

  def self.find_by_provider_or_email(email, provider)
    User.where('providers.email' => email, 'providers.name' => provider)
  end
end
