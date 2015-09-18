require 'spec_helper'

describe Oauth::RefreshTokenTokenGenerator do
  let(:client) { Fabricate(:client, secret: 'secret') }
  let(:access_token) { AccessToken.build('42', token: 'access') }
  let(:refresh_token) { RefreshToken.build(token: 'refresh') }
  let(:params) { {} }
  let(:req) { double('request', refresh_token: refresh_token.token, params: params) }

  describe '.generate' do
    subject { Oauth::RefreshTokenTokenGenerator.generate(client, req) }

    context 'when resource is not present' do
      before { params['resource_type'] = '' }

      it 'delegates generate to the RefreshTokenUserTokenGenerator' do
        expect(Oauth::RefreshTokenUserTokenGenerator).to receive(:generate).with(client, req)

        subject
      end
    end

    context 'when resource is user' do
      before { params['resource_type'] = 'user' }

      it 'delegates generate to the RefreshTokenUserTokenGenerator' do
        expect(Oauth::RefreshTokenTokenGenerator).to receive(:generate).with(client, req)

        subject
      end
    end

    context 'when resource is user_client_association' do
      before { params['resource_type'] = 'user_client_association' }

      it 'delegates generate to the RefreshTokenUserClientAssociationTokenGenerator' do
        expect(Oauth::RefreshTokenUserClientAssociationTokenGenerator).to receive(:generate).with(client, req)

        subject
      end
    end
  end
end