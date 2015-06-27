require 'spec_helper'

describe API::Entities::User do
  include_context :with_authenticated_user

  let(:options) { {} }
  let(:entity) { JSON.parse(API::Entities::User.new(user, options).to_json) }

  describe 'contacts_updated_at' do
    subject { entity['contacts_updated_at'] }

    context 'is nil' do
      before do
        user.contacts_updated_at = nil
      end

      it { is_expected.to be_nil }
    end

    context 'is not nil' do
      before do
        user.contacts_updated_at = Date.today
      end

      it { is_expected.to eq user.contacts_updated_at.iso8601 }
    end
  end

  describe 'access_token' do
    subject { entity['access_token'] }

    context 'with a client_id' do
      include_context :with_authenticated_client

      let(:options) { { client_id: client.id } }

      context 'and a active token for that client' do
        let!(:access_token) { GenerateOauthToken.build_access_token_for(user, client.id) }

        it { is_expected.to eq access_token.token }
      end
    end

    context 'with no client_id' do
      context 'and a active token' do
        let!(:access_token) { GenerateOauthToken.build_access_token_for(user, '42') }

        it { is_expected.to eq access_token.token }
      end
    end
  end
end
