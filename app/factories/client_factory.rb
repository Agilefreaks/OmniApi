class ClientFactory
  class << self
    def create_web_client(id = nil)
      create_client(id, 'WebClient', :web_client)
    end

    def create_android_client(id = nil)
      create_client(id, 'AndroidClient', :android_client)
    end

    def create_win_client(id = nil)
      create_client(id, 'WinClient', :win_client)
    end

    private

    def create_client(id = nil, name, group)
      client = Client.new do |c|
        c.name = name
        c._id = id unless id.nil?
      end
      access_token = AccessToken.build
      access_token.expires_at = Time.now.utc + 1.year
      access_token.scopes = ScopesRepository.get(group)
      client.access_tokens.push(access_token)
      client.save

      client
    end
  end
end
