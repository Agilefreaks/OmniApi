require 'spec_helper'

describe API::Entities::UserClientAssociation do
  let(:user) { Fabricate(:user) }
  let(:client) { Fabricate(:client) }
  let(:refresh_token) { AccessToken.new({token: 'testRefreshToken'}) }
  let(:token) { AccessToken.new(client: client, refresh_token: refresh_token, token: 'testToken', expires_at: 3.days.from_now) }
  let(:user_client_association) { UserClientAssociation.create!({access_token: token, user: user, client: client}) }

  describe '#to_json' do
    let(:options) { {} }
    subject { JSON.parse(API::Entities::UserClientAssociation.new(user_client_association, options).to_json) }

    its(['refresh_token']) { is_expected.to eq('testRefreshToken') }
  end
end