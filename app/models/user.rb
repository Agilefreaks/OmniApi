require_relative 'concerns/oauth2_user'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::OAuth2User

  field :first_name, type: String
  field :last_name, type: String

  # Database authenticatable
  field :email, :type => String, :default => ''
  field :encrypted_password, :type => String, :default => ''

  # Recoverable
  field :reset_password_token, :type => String
  field :reset_password_sent_at, :type => Time

  # Rememberable
  field :remember_created_at, :type => Time

  # Trackable
  field :sign_in_count, :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at, :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip, :type => String

  validates_uniqueness_of :email

  embeds_many :registered_devices
  accepts_nested_attributes_for :registered_devices

  embeds_many :clippings
  accepts_nested_attributes_for :clippings

  embeds_many :providers
  accepts_nested_attributes_for :providers

  def active_registered_devices
    registered_devices.active
  end

  def self.find_by_provider_or_email(email, provider)
    User.where('providers.email' => email, 'providers.name' => provider)
  end
end
