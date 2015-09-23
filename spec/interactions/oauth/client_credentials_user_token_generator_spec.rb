require 'spec_helper'

describe Oauth::ClientCredentialsUserTokenGenerator do
  let(:params) { {} }
  let(:client) { Fabricate(:client, secret: 'test') }
  let(:req) { double('request', client_secret: client.secret, params: params) }

  describe '.generate' do
    subject { Oauth::ClientCredentialsUserTokenGenerator.generate(client, req) }

    context 'when an email is provided' do
      before { params['resource_id'] = 'test@email.com' }

      context 'and the given email corresponds to an existing user' do
        let!(:user) { Fabricate(:user, email: params['resource_id']) }

        it 'will create an access token for the given client on the user' do
          expect { subject }.to change { user.reload.access_tokens.count }.by(1)
        end

        its(:token) { should == user.reload.access_tokens.last.token }

        its(:refresh_token) { should_not be_nil }
      end
    end
  end
end
