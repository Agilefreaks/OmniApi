require 'spec_helper'

describe :AuthenticationHelper do
  class AuthenticationHelperTest
    include AuthenticationHelper

    attr_reader :current_token, :current_user, :current_client
  end

  let(:authentication_helper) { AuthenticationHelperTest.new }
  let(:request) { Rack::Request.new("#{Rack::OAuth2::Server::Resource::ACCESS_TOKEN}" => token) }

  before do
    allow(authentication_helper).to receive(:request).and_return(request)
  end

  describe :require_oauth_token do
    subject { authentication_helper.require_oauth_token }

    context 'when no token is provided' do
      let(:token) { nil }

      it 'will fail' do
        expect { subject }.to raise_error(Rack::OAuth2::Server::Resource::Bearer::Unauthorized)
      end
    end

    context 'when token is provided' do
      let(:token) { AccessToken.new }

      it 'will not fail' do
        expect { subject }.not_to raise_error
      end

      it 'will set current_token' do
        subject
        expect(authentication_helper.current_token).to eq token
      end
    end
  end

  describe :authenticate! do
    subject { authentication_helper.authenticate! }

    let(:token) { AccessToken.new(token: 'when the spell is broken') }

    before do
      allow(User).to receive(:find_by_token).and_return(user)
    end

    context 'when there is no user with specific token' do
      let(:user) { nil }

      it 'will fail' do
        expect { subject }.to raise_error(Rack::OAuth2::Server::Resource::Bearer::Unauthorized)
      end
    end

    context 'when there is a user with specific token' do
      let(:user) { ::User.new(access_tokens: [token], email: 'make@way.com') }

      it 'will not fail' do
        expect { subject }.not_to raise_error
      end

      it 'will set current token' do
        subject
        expect(authentication_helper.current_token).to eq token
      end

      it 'will set current user' do
        subject
        expect(authentication_helper.current_user).to eq user
      end

      it 'will set custom params for new relic' do
        expect(NewRelic::Agent).to receive(:add_custom_parameters).with(user_email: 'make@way.com')
        subject
      end
    end
  end

  describe :authenticate_client! do
    subject { authentication_helper.authenticate_client! }

    let(:token) { AccessToken.new(token: 'when the spell is broken') }

    before do
      allow(Client).to receive(:find_by_token).and_return(client)
    end

    context 'when there is no client with specific token' do
      let(:client) { nil }

      it 'will fail' do
        expect { subject }.to raise_error(Rack::OAuth2::Server::Resource::Bearer::Unauthorized)
      end
    end

    context 'when there is a client with specific token' do
      let(:client) { ::Client.new(access_tokens: [token], name: 'home') }

      it 'will not fail' do
        expect { subject }.not_to raise_error
      end

      it 'will set current token' do
        subject
        expect(authentication_helper.current_token).to eq token
      end

      it 'will set current client' do
        subject
        expect(authentication_helper.current_client).to eq client
      end

      it 'will set custom params for new relic' do
        expect(NewRelic::Agent).to receive(:add_custom_parameters).with(client_name: 'home')
        subject
      end
    end
  end
end
