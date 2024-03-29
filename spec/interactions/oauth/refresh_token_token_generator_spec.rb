require 'spec_helper'

describe Oauth::RefreshTokenTokenGenerator do
  let(:client) { Fabricate(:client, secret: 'secret') }
  let(:access_token) { AccessToken.build('42', token: 'access') }
  let(:refresh_token) { RefreshToken.build(token: 'refresh') }
  let(:req) { double('request', refresh_token: refresh_token.token) }
  let(:user) { Fabricate(:user) }

  describe '.generate' do
    subject { Oauth::RefreshTokenTokenGenerator.generate(client, req) }

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

    context 'when refresh token is invalid' do
      it 'invalidates the request' do
        expect(req).to receive(:invalid_grant!).and_raise(Rack::OAuth2::Server::Resource::BadRequest)

        expect { subject }.to raise_error Rack::OAuth2::Server::Resource::BadRequest
      end
    end
  end
end
