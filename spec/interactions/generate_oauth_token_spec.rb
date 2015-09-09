require 'spec_helper'

describe :GenerateOauthToken do
  let(:client) { Fabricate(:client, secret: 'secret') }

  describe GenerateOauthToken::ClientCredentials do
    let(:params) { {} }
    let(:req) { double('request', client_secret: secret, params: params) }

    subject { GenerateOauthToken::ClientCredentials.create(client, req) }

    context 'when secret is valid' do
      let(:secret) { 'secret' }

      context 'and an email is not provided' do
        it 'will create a access token on the client' do
          expect { subject }.to change(client.access_tokens, :count).by(1)
        end

        its(:token) { should == client.access_tokens.last.token }
      end

      context 'and an email is provided' do
        before { params['user_email'] = 'test@email.com' }

        context 'and the given email corresponds to an existing user' do
          let!(:user) { Fabricate(:user, email: params['user_email']) }

          it 'will create an access token for the given client on the user' do
            expect { subject }.to change {user.reload.access_tokens.count }.by(1)
          end

          its(:token) { should == user.reload.access_tokens.last.token }
        end
      end

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
    let(:access_token) { AccessToken.build('42', token: 'access') }
    let(:refresh_token) { RefreshToken.build(token: 'refresh') }
    let(:req) { double('request', refresh_token: refresh_token.token) }
    let(:user) { Fabricate(:user) }

    subject { GenerateOauthToken::RefreshToken.create(client, req) }

    context 'when refresh token is valid' do
      before :each do
        access_token.refresh_token = refresh_token
        user.access_tokens.push(access_token)
        user.save
      end

      it 'will not create a new access token' do
        expect { subject }.to change(user.access_tokens, :count).by(0)
      end

      context 'if access_token is expired' do
        before do
          access_token.expires_at = Time.now.utc - 2.months
          user.save
        end

        its(:expires_at) { should >= Time.now.utc }
      end

      its(:client_id) { should == '42' }

      its('refresh_token.token') { should eq 'refresh' }
    end
  end
end
