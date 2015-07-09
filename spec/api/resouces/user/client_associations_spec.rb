require 'spec_helper'

describe API::Resources::User::ClientAssociations do
  include_context :with_authenticated_user

  describe "POST '/api/v1/user/client_associations'" do
    let(:client) { Fabricate(:classified_add_client, name: 'Test', url: 'https://some-url.com/') }
    let(:client_id) { client.id.to_s }
    let(:params) { { client_id: client_id } }
    let(:action) { post '/api/v1/user/client_associations', params.to_json, options }

    subject { action }

    its(:status) { is_expected.to eq(201) }

    it 'creates a UserClientAssociation' do
      subject

      expect(UserClientAssociation.find_by_client_id(client_id)).not_to be_nil
    end

    describe 'response body' do
      subject { JSON.parse(action.body) }

      its(['token']) { is_expected.to eq(user.reload.access_tokens.last.token) }

      its(['client_id']) { is_expected.to eq(client_id) }

      its(['client_name']) { is_expected.to eq('Test') }

      its(['client_url']) { is_expected.to eq('https://some-url.com/') }
    end

    context 'client does not exist' do
      let(:client_id) { '42' }

      its(:status) { is_expected.to eq(404) }
    end
  end

  describe "GET '/api/v1/user/client_associations/:client_id'" do
    let(:client) { Fabricate(:classified_add_client, name: 'Test', url: 'https://some-url.com/') }
    let(:client_id) { client.id.to_s }
    let(:action) { get "/api/v1/user/client_associations/#{client_id}", '', options }

    subject { action }

    context 'user_client_association exists' do
      before do
        CreateUserClientAssociation.between(user, client)
      end

      describe 'response body' do
        subject { JSON.parse(action.body) }

        its(['token']) { is_expected.to eq(user.access_tokens.last.token) }

        its(['client_id']) { is_expected.to eq(client_id) }

        its(['client_name']) { is_expected.to eq('Test') }

        its(['client_url']) { is_expected.to eq('https://some-url.com/') }
      end
    end

    context 'user_client_association does not exists' do
      before do
        CreateUserClientAssociation.between(Fabricate(:user), client)
      end

      it { is_expected.to be_not_found }
    end
  end
end
