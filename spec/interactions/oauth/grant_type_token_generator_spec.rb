require 'spec_helper'

describe Oauth::GrantTypeTokenGenerator do
  describe '.generate' do
    let(:client) { Fabricate(:client, secret: 'secret') }
    let(:req) { double('request', code: '42') }

    subject { Oauth::GrantTypeTokenGenerator.generate(client, req) }

    [
      { grant_type: :refresh_token, generator: Oauth::RefreshTokenTokenGenerator },
      { grant_type: :client_credentials, generator: Oauth::ClientCredentialsTokenGenerator },
      { grant_type: :authorization_code, generator: Oauth::AuthorizationCodeTokenGenerator }
    ].each do |test_data|
      context "grant_type is #{test_data[:grant_type]}" do
        before { allow(req).to receive(:grant_type).and_return(test_data[:grant_type]) }

        it "delegates the result to #{test_data[:generator]}" do
          expect(test_data[:generator]).to receive(:generate).with(client, req)

          subject
        end
      end
    end
  end
end
