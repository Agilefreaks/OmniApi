class AuthorizationCode
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_EXPIRATION_TIME = 5.minutes

  default_scope -> { where(active: true, :expires_at.gt => Time.now.utc) }

  field :code, type: String, default: -> { Random.new(Time.now.utc.to_i).rand(100_000..999_999) }
  field :expires_at, type: DateTime, default: -> { Time.now.utc + DEFAULT_EXPIRATION_TIME }
  field :active, type: Boolean, default: true

  embedded_in :user

  validates_presence_of :code
end
