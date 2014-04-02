require 'spec_helper'

describe DeactivateDevice do
  describe 'with' do
    include_context :with_authentificated_user

    subject { DeactivateDevice.with(access_token => access_token.token, identifier: 'violin') }

    context 'with an existing registered device' do
      before :each do
        user.registered_devices.create(identifier: 'violin', registration_id: '42')
      end

      its(:registration_id) { should be_nil }
    end

    context 'with no existing device' do
      it 'will raise and exception' do
        expect { subject }.to raise_exception(Mongoid::Errors::DocumentNotFound)
      end
    end
  end
end
