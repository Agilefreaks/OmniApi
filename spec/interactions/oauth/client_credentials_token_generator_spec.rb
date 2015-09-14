require 'spec_helper'

describe Oauth::ClientCredentialsTokenGenerator do
  let(:params) { {} }
  let(:secret) { 'test' }
  let(:client) { Fabricate(:client, secret: secret) }
  let(:req) { double('request', client_secret: secret, params: params) }

  describe '.generate' do
    subject { Oauth::ClientCredentialsTokenGenerator.generate(client, req) }

    [
      {resource: :user, generator: Oauth::ClientCredentialsUserTokenGenerator},
      {resource: :client, generator: Oauth::ClientCredentialsClientTokenGenerator}
    ].each do |test_data|
      context "resource is #{test_data[:resource]}" do
        before { params['resource_type'] = test_data[:resource] }

        it "delegates the result to #{test_data[:generator]}" do
          expect(test_data[:generator]).to receive(:generate).with(client, req)

          subject
        end
      end
    end
  end
end