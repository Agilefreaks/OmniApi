require_relative 'base_token_generator'

module Oauth
  class BaseClientCredentialsTokenGenerator < Oauth::BaseTokenGenerator
    def self.authorize!(client, req)
      req.invalid_grant! unless client.secret == req.client_secret
    end
  end
end
