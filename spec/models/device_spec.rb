require 'spec_helper'

describe Device do
  it { should be_embedded_in :user }

  describe 'active' do
    let(:user) { Fabricate(:user) }
    let!(:active_device) { user.devices.create(registration_id: '1') }
    let!(:inactive_device) { user.devices.create }

    it 'will return only active devices' do
      expect(user.devices.active.entries).to eq [active_device]
    end
  end
end
