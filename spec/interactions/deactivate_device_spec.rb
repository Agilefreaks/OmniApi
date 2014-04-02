require 'spec_helper'

describe DeactivateDevice do
  describe 'with' do
    let(:user) { Fabricate(:user) }
    let(:access_token) { AccessToken.build }

    before do
      user.access_tokens.push(access_token)
      user.save
    end

    subject { DeactivateDevice.with(access_token => access_token.token, identifier: 'violin') }

    context 'with an existing registered device' do
      before :each do
        user.registered_devices.create(identifier: 'violin', registration_id: '42')
      end

      its(:registration_id) { should == nil }
    end

    context 'with no existing device' do
      it 'will raise and exception' do
        expect { subject }.to raise_exception(Mongoid::Errors::DocumentNotFound)
      end
    end
  end
end
