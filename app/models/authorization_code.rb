class AuthorizationCode
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_EXPIRATION_TIME = 1.hour

  default_scope -> { where(valid: true, :expires_at.gt => Time.now.utc) }

  field :code, type: String, default: -> { Random.new(Time.now.utc.to_i).rand(100000..9999999) }
  field :expires_at, type: DateTime, default: -> { Time.now.utc + DEFAULT_EXPIRATION_TIME }
  field :valid, type: Boolean, default: true

  embedded_in :user

  validates_presence_of :code
end
