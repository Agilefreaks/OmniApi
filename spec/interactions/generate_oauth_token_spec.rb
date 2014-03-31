require 'spec_helper'

describe :GenerateOauthToken do
  let(:client) { Fabricate(:client, secret: 'secret') }

  describe GenerateOauthToken::ClientCredentials do
    let(:req) { double('request', client_secret: secret) }

    subject { GenerateOauthToken::ClientCredentials.create(client, req) }

    context 'when secret is valid' do
      let(:secret) { 'secret' }

      it 'will create a access token on the client' do
        expect { subject }.to change(client.access_tokens, :count).by(1)
      end

      its(:token) { should == client.access_tokens.last.token }

      its(:refresh_token) { should_not be_nil }
    end
  end

  describe GenerateOauthToken::AuthorizationCode do
    let(:req) { double('request', code: '42') }
    let(:user) { Fabricate(:user) }

    subject { GenerateOauthToken::AuthorizationCode.create(client, req) }

    context 'when code is valid' do
      before :each do
        allow(User).to receive(:find_by_code).and_return(user)
        allow(user).to receive(:invalidate_authorization_code)
      end

      it 'will create a new access token' do
        expect { subject }.to change(user.access_tokens, :count).by(1)
      end

      its(:token) { should == user.access_tokens.last.token }

      its(:client_id) { should == client.id }

      its(:refresh_token) { should_not be_nil }
    end
  end

  describe GenerateOauthToken::RefreshToken do
    let(:req) { double('request', refresh_token: '42') }
    let(:user) { Fabricate(:user) }

    subject { GenerateOauthToken::RefreshToken.create(client, req) }

    context 'when refresh token is valid' do
      before :each do
        allow(User).to receive(:find_by_token).and_return(user)
      end

      it 'will create a new access token' do
        expect { subject }.to change(user.access_tokens, :count).by(1)
      end

      its(:token) { should == user.access_tokens.last.token }

      its(:client_id) { should == client.id }

      its(:refresh_token) { should_not be_nil }
    end
  end
end
