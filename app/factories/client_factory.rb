class ClientFactory
  class << self
    def create_web_client
      create_client('WebClient', :web_client)
    end

    def create_android_client
      create_client('AndroidClient', :android_client)
    end

    def create_win_client
      create_client('WinClient', :win_client)
    end

    private

    def create_client(name, group)
      client = Client.new(name: name)
      access_token = AccessToken.build
      access_token.expires_at = Date.current + 1.year
      access_token.scopes = ScopesRepository.get(group)
      client.access_tokens.push(access_token)
      client.save

      client
    end
  end
end
