require 'spec_helper'

describe API::Resources::User::ClientAssociations do
  include_context :with_authenticated_user

  describe "POST '/api/v1/user/client_associations'" do
    let(:scope) { Fabricate(:scope) }
    let(:client) { Fabricate(:client, name: 'Test', url: 'https://some-url.com/', scopes: [scope]) }
    let(:client_id) { client.id.to_s }
    let(:params) { {client_id: client_id} }
    let(:action) { post '/api/v1/user/client_associations', params.to_json, options }

    subject { action }

    its(:status) { is_expected.to eq(201) }

    it 'creates a UserClientAssociation' do
      subject

      expect(UserClientAssociation.find_by_client_id(client_id)).not_to be_nil
    end

    describe 'response body' do
      subject { JSON.parse(action.body) }

      its(['client_id']) { is_expected.to eq(client_id) }

      its(['client_name']) { is_expected.to eq('Test') }

      its(['client_url']) { is_expected.to eq('https://some-url.com/') }

      its(['scopes']) { is_expected.to eq([{'id' => scope.id.to_s, 'key' => scope.key.to_s, 'description' => scope.description.to_s}]) }
    end

    context 'client does not exist' do
      let(:client_id) { '42' }

      its(:status) { is_expected.to eq(404) }
    end
  end
end
