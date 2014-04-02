require 'spec_helper'

describe Register do
  describe 'execute' do
    let(:user) { Fabricate(:user) }
    let(:access_token) { AccessToken.build }

    before do
      user.access_tokens.push(access_token)
      user.save
    end

    subject { Register.device(:access_token => access_token.token, :identifier => 'Tu La', :name => 'Tu mem') }

    shared_examples :registered_device do
      its(:user) { should == user }

      its(:identifier) { should == 'Tu La' }

      its(:name) { should == 'Tu mem' }
    end

    context 'when user has a device with the same identifier' do
      let!(:registered_device) { user.registered_devices.create(identifier: 'Tu La') }

      it_behaves_like :registered_device

      it { should == registered_device }
    end

    context 'when the user has no device' do
      it_behaves_like :registered_device
    end
  end
end
