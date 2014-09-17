require 'spec_helper'

describe ActivateDevice do
  describe 'with' do
    include_context :with_authentificated_user

    # rubocop:disable LineLength
    subject { ActivateDevice.with(access_token: access_token.token, identifier: 'flute', registration_id: '42', provider: :omni_sync, client_version: '42') }

    context 'with an existing registered device' do
      before :each do
        user.registered_devices.create(identifier: 'flute')
      end

      its(:registration_id) { is_expected.to eq '42' }

      its(:provider) { is_expected.to eq :omni_sync }

      its(:client_version) { is_expected.to eq '42' }
    end

    context 'with no existing device' do
      it 'will raise and exception' do
        expect { subject }.to raise_exception(Mongoid::Errors::DocumentNotFound)
      end
    end
  end
end
