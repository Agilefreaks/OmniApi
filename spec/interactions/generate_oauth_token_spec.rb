require 'spec_helper'

describe :GenerateOauthToken do
  describe :ClientCredentials do
    let(:client) { Fabricate(:client, secret: 'secret') }
    let(:req) { double('request', client_secret: secret) }

    subject { GenerateOauthToken::ClientCredentials.create(client, req) }

    context 'when secret is valid' do
      let(:secret) { 'secret' }

      it 'will create a access token on the client' do
        expect { subject }.to change(client.access_tokens, :count).by(1)
      end
    end
  end
end
