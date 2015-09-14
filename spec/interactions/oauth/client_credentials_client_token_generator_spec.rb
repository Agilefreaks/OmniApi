require 'spec_helper'

describe Oauth::ClientCredentialsClientTokenGenerator do
  let(:params) { {} }
  let(:client) { Fabricate(:client, secret: 'test') }
  let(:req) { double('request', client_secret: client.secret, params: params) }

  describe '.generate' do
    subject { Oauth::ClientCredentialsClientTokenGenerator.generate(client, req) }

    context 'when secret is valid' do
      let(:secret) { 'secret' }

      it 'will create a access token on the client' do
        expect { subject }.to change(client.access_tokens, :count).by(1)
      end

      its(:token) { should == client.access_tokens.last.token }
    end
  end
end