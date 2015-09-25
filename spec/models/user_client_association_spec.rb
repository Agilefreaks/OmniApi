require 'spec_helper'

describe UserClientAssociation do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:client) }
  it { is_expected.to have_field(:scopes).of_type(Array) }

  describe :find_by_client_id do
    let(:client_id) { '42' }
    subject { UserClientAssociation.find_by_client_id(client_id) }

    context 'the item does not exist' do
      before do
        UserClientAssociation.where(client_id: client_id).delete_all
      end

      it 'raises not found exception' do
        expect do
          subject
        end.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    context 'the item exists' do
      let!(:instance) { Fabricate(:user_client_association) }
      let(:client_id) { instance.client_id }

      it { is_expected.to eq(instance) }
    end
  end

  describe '#access_token' do
    context 'the association has a client and user set' do
      let!(:instance) { Fabricate(:user_client_association) }

      subject { instance.access_token }

      context 'the user has an access token for the equivalent client' do
        let!(:access_token) do
          access_token = AccessToken.build(instance.client.id)
          instance.user.access_tokens.push(access_token)
          access_token
        end

        it { is_expected.to eq access_token }
      end

      context 'the user does not have an access token for the equivalent client' do
        let!(:access_token) { instance.user.access_tokens.destroy_all }

        it { is_expected.to be_nil }
      end
    end
  end
end
