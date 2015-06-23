require 'spec_helper'

describe UserClientAssociation do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:client) }
  it { is_expected.to embed_many(:scopes) }

  describe 'find_by_client_id' do
    let(:client_id) { '42' }
    subject { UserClientAssociation.find_by_client_id(client_id) }

    context 'the item does not exist' do
      before do
        UserClientAssociation.where(client_id: client_id).delete_all
      end

      it 'raises not found exception' do
        expect {
          subject
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    context 'the item exists' do
      let!(:instance) { Fabricate(:user_client_association) }
      let(:client_id) { instance.client_id }

      it { is_expected.to eq(instance) }
    end
  end
end
