class ClientFactory
  class << self
    def create_web_client(id = nil)
      create_client(id: id, name: 'WebClient', group: :web_client)
    end

    def create_android_client(id = nil)
      create_client(id: id, name: 'AndroidClient', group: :android_client)
    end

    def create_win_client(id = nil)
      create_client(id: id, name: 'WinClient', group: :win_client)
    end

    def create_omnikiq_client(id = nil)
      create_client(id: id, name: 'OmnikiqClient', group: :omnikiq_client)
    end

    # rubocop:disable AbcSize
    def create_client(id: nil, name:, group: nil)
      client = ::Client.new do |c|
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
