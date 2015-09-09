module Oauth
  class BaseTokenGenerator
    def self.generate(client, req)
      self.authorize!(client, req)
      self.generate_core(client, req)
    end

    def self.build_access_token_for(access_tokens_holder, client_id = nil)
      access_token = AccessToken.build(client_id)
      access_token.refresh_token = ::RefreshToken.build(client_id)
      access_tokens_holder.access_tokens.push(access_token)
      access_tokens_holder.save!
      access_token
    end

    protected

    def self.authorize!(client, req)
      raise NotImplementedError
    end

    def self.generate_core(client, req)
      raise NotImplementedError
    end
  end
end