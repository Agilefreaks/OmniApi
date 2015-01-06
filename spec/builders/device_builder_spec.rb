require 'spec_helper'

describe DeviceBuilder do
  include_context :with_authenticated_user

  describe :build do
    let(:params) { { name: 'Device name', client_version: '1', public_key: '42' } }

    subject { DeviceBuilder.new.build(access_token.token, params) }

    it { is_expected.not_to be_new_record }

    its(:name) { is_expected.to eq 'Device name' }
  end
end
