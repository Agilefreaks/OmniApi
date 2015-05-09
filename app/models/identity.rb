class Identity
  include Mongoid::Document
  include Mongoid::Timestamps

  field :provider, type: String
  field :scope, type: String
  field :expires, type: Boolean
  field :expires_at, type: DateTime
  field :token, type: String
  field :refresh_token, type: String

  embedded_in :user
end
