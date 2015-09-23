module Oauth
  class BaseTokenGenerator
    def self.generate(client, req)
      authorize!(client, req)
      generate_core(client, req)
    end

    def self.build_access_token_for(access_tokens_holder, client_id = nil)
      access_token = AccessToken.build(client_id)
      access_token.refresh_token = ::RefreshToken.build(client_id)
      access_tokens_holder.access_tokens.push(access_token)
      access_tokens_holder.save!
      access_token
    end

    def self.authorize!(_client, _req)
      fail NotImplementedError
    end

    def self.generate_core(_client, _req)
      fail NotImplementedError
    end
  end
end
