require 'spec_helper'

describe Oauth::RefreshTokenUserClientAssociationTokenGenerator do
  describe '.generate' do
    let(:client) { Fabricate(:client) }
    let(:refresh_token) { RefreshToken.new(token: 'testToken') }
    let(:req) { double('request', refresh_token: refresh_token.token) }

    subject { Oauth::RefreshTokenUserClientAssociationTokenGenerator.generate(client, req) }

    context 'a user_client_association exists with the given refresh token' do
      let(:user) { Fabricate(:user) }
      let(:token) do
        AccessToken.new(client: client, user: user, expires_at: 3.days.from_now,
                        refresh_token: refresh_token, token: 'tt')
      end

      let!(:user_client_association) { UserClientAssociation.create!(user: user, client: client, access_token: token) }

      it 'updates the expiration date of the corresponding token' do
        current_time = DateTime.now.utc
        expected_time = current_time + Concerns::OAuth2Token::DEFAULT_EXPIRATION_TIME
        Timecop.freeze(current_time) do
          subject

          expect(user_client_association.reload.access_token.expires_at.to_s(:db)).to eq(expected_time.to_s(:db))
        end
      end
    end
  end
end
