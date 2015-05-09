require 'spec_helper'

describe API::Resources::Users::Identities do
  describe 'POST /api/v1/users/:user_id/identities' do
    include_context :with_authenticated_web_client

    before do
      Fabricate(:user, id: '42')
    end

    let(:user) { User.find('42') }
    let(:params) {
      {
        user_id: '42',
        provider: 'Google',
        scope: 'profile.email,calendar.readonly',
        expires: true,
        expires_at: DateTime.now,
        token: 'token',
        refresh_token: 'refresh_token'
      }
    }

    subject { post '/api/v1/users/42/identities', params.to_json, options }

    its(:status) { is_expected.to be 201 }

    it 'creates a new identity for the user' do
      subject

      expect(user.identity).to be_a Identity
    end

    its(:body)
  end
end