require 'spec_helper'

describe Register do
  describe 'execute' do
    include_context :with_authenticated_user

    # rubocop:disable LineLength
    subject { Register.device(access_token: access_token.token, identifier: 'Tu La', name: 'Tu mem', client_version: '42') }

    shared_examples :registered_device do
      its(:user) { should == user }

      its(:identifier) { should == 'Tu La' }

      its(:name) { should == 'Tu mem' }

      its(:client_version) { should == '42' }
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
