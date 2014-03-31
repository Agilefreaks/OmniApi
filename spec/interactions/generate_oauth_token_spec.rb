require 'spec_helper'

describe :GenerateOauthToken do
  let(:client) { Fabricate(:client, secret: 'secret') }

  describe :ClientCredentials do
    let(:req) { double('request', client_secret: secret) }

    subject { GenerateOauthToken::ClientCredentials.create(client, req) }

    context 'when secret is valid' do
      let(:secret) { 'secret' }

      it 'will create a access token on the client' do
        expect { subject }.to change(client.access_tokens, :count).by(1)
      end

      its(:token) { should == client.access_tokens.last.token }
    end
  end

  describe :AuthorizationCode do
    let(:req) { double('request', code: '42') }
    let(:user) { Fabricate(:user) }

    subject { GenerateOauthToken::AuthorizationCode.create(client, req) }

    context 'when code is valid' do
      before :each do
        allow(User).to receive(:find_by_code).and_return(user)
      end

      it 'will create a new access token' do
        expect { subject }.to change(user.access_tokens, :count).by(1)
      end

      its(:token) { should == user.access_tokens.last.token }
    end
  end
end
