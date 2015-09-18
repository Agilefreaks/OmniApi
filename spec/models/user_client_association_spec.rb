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

  describe :find_by_token do
    let(:token) { 'someToken' }
    subject { UserClientAssociation.find_by_token(token) }

    context 'the item does not exist' do
      before { UserClientAssociation.delete_all }

      it { is_expected.to be_nil }
    end

    context 'the user client association exists' do
      let(:user) { Fabricate(:user) }
      let(:client) { Fabricate(:client) }
      let(:refresh_token) { RefreshToken.new(token: token) }
      let(:access_token) { AccessToken.new(client: client, user: user, token: 't', expires_at: DateTime.now, refresh_token: refresh_token) }
      let!(:user_client_association) { UserClientAssociation.create!(client: client, user: user, access_token: access_token) }

      it { is_expected.to eq user_client_association }
    end
  end
end
