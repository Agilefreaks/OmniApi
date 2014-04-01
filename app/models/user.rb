require_relative 'concerns/oauth2_user'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::OAuth2User

  field :first_name, type: String
  field :last_name, type: String

  embeds_many :registered_devices
  accepts_nested_attributes_for :registered_devices
end
