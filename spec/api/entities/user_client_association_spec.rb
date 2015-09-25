require 'spec_helper'

describe API::Entities::UserClientAssociation do
  let(:user) { Fabricate(:user) }
  let(:client) { Fabricate(:client) }
  let(:user_client_association) { UserClientAssociation.create!(user: user, client: client) }

  describe '#to_json' do
    let(:options) { {} }

    subject { JSON.parse(API::Entities::UserClientAssociation.new(user_client_association, options).to_json) }

    context 'a corresponding access_token exists' do
      let(:refresh_token) { RefreshToken.new(token: 'testRefreshToken') }
      let!(:token) do
        token = AccessToken.build(client.id)
        token.refresh_token = refresh_token
        user.access_tokens.push(token)
        token
      end

      its(['refresh_token']) { is_expected.to eq('testRefreshToken') }
    end
  end
end
