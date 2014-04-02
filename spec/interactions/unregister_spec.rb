require 'spec_helper'

describe Unregister do
  describe :execute do
    let(:user) { Fabricate(:user) }
    let(:access_token) { AccessToken.build }
    let(:identifier) { '132' }

    before do
      user.access_tokens.push(access_token)
      user.save
    end

    subject { Unregister.device(access_token: access_token.token, identifier: identifier) }

    context 'with a existing device' do
      before :each do
        user.registered_devices.create(identifier: identifier)
      end

      it 'will delete the existing device' do
        expect { subject }.to change { user.reload; user.registered_devices.count }.from(1).to(0)
      end
    end

    context 'with a non existing device' do
      it 'will raise DocumentNotFound' do
        expect { subject }.to raise_exception(Mongoid::Errors::DocumentNotFound)
      end
    end
  end
end
