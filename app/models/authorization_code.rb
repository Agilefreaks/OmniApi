class AuthorizationCode
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_EXPIRATION_TIME = 1.hour

  field :code, type: String, default: -> { '12345' }
  field :expires_in, type: Integer, default: -> { DEFAULT_EXPIRATION_TIME }

  embedded_in :user

  validates_presence_of :code
end
