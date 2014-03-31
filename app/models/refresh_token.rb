require_relative 'concerns/oauth2_token'

class RefreshToken
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::OAuth2Token

  embedded_in :access_token
end
