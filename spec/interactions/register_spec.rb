require 'spec_helper'

describe Register do
  describe 'execute' do
    include_context :with_authenticated_user

    # rubocop:disable LineLength
    let(:params) { { access_token: access_token.token, identifier: 'Tu La', name: 'Tu mem', client_version: '42', public_key: 'public' } }

    subject { Register.device(params) }

    shared_examples :registered_device do
      its(:user) { is_expected.to eq user }

      its(:identifier) { is_expected.to eq 'Tu La' }

      its(:name) { is_expected.to eq 'Tu mem' }

      its(:client_version) { is_expected.to eq '42' }

      its(:public_key) { is_expected.to eq 'public' }
    end

    context 'when user has a device with the same identifier' do
      before :each do
        user.registered_devices.create(identifier: 'Tu La')
      end

      it_behaves_like :registered_device

      it 'will have only one registered device' do
        subject
        user.reload
        expect(user.registered_devices.count).to eq 1
      end
    end

    context 'when the user has no device' do
      it_behaves_like :registered_device
    end
  end
end
