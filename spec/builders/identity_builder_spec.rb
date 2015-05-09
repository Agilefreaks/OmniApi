require 'spec_helper'

describe IdentityBuilder do
  describe :build do
    before do
      Fabricate(:user, id: '42')
    end

    let(:user) { User.find('42') }
    let(:expiration_date) { DateTime.now }
    let(:params) do
      {
        user_id: '42',
        provider: 'Google',
        scope: 'profile.email,calendar.readonly',
        expires: true,
        expires_at: expiration_date,
        token: 'token',
        refresh_token: 'refresh_token'
      }
    end

    subject { IdentityBuilder.for('42').build(params) }

    its(:provider) { is_expected.to eq 'Google' }

    its(:scope) { is_expected.to eq 'profile.email,calendar.readonly' }

    its(:expires) { is_expected.to be true }

    its(:expires_at) { is_expected.to eq expiration_date }

    its(:token) { is_expected.to eq 'token' }

    its(:refresh_token) { is_expected.to eq 'refresh_token' }
  end
end
