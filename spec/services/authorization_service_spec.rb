require 'spec_helper'

describe AuthorizationService do
  describe :verify do
    let(:authorization_error) { Rack::OAuth2::Server::Resource::Bearer::Unauthorized }
    let(:resource) { :mock_resource }
    let(:method) { :create }

    subject { AuthorizationService.verify(resource, method, token) }

    context 'when access token has no roles' do
      let(:token) { AccessToken.new }

      it 'will throw an authorization error' do
        expect { subject }.to raise_error(authorization_error)
      end
    end

    context 'when access token has roles' do
      let(:token) { AccessToken.new(roles: [:mock_resource_create]) }

      it 'will not raise and error' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
