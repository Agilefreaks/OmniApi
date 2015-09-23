require 'spec_helper'

describe Oauth::AuthorizationCodeTokenGenerator do
  let(:client) { Fabricate(:client, secret: 'secret') }
  let(:req) { double('request', code: '42') }
  let(:user) { Fabricate(:user) }

  describe '.generate' do
    subject { Oauth::AuthorizationCodeTokenGenerator.generate(client, req) }

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
end
