require 'spec_helper'

describe ActivateDevice do
  describe 'with' do
    include_context :with_authentificated_user

    # rubocop:disable LineLength
    subject { ActivateDevice.with(access_token: access_token.token, identifier: 'flute', registration_id: '42', provider: :omni_sync) }

    context 'with an existing registered device' do
      before :each do
        user.registered_devices.create(identifier: 'flute')
      end

      its(:registration_id) { should == '42' }

      its(:provider) { should == :omni_sync }
    end

    context 'with no existing device' do
      it 'will raise and exception' do
        expect { subject }.to raise_exception(Mongoid::Errors::DocumentNotFound)
      end
    end
  end
end
