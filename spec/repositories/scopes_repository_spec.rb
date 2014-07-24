require 'spec_helper'

describe ScopesRepository do
  describe :get do
    subject { ScopesRepository.get(group) }

    context 'for web_client' do
      let(:group) { :web_client }

      it { is_expected.to include(:authorization_codes_create, :users_create) }
    end

    context 'for android_client' do
      let(:group) { :android_client }

      it { is_expected.to include(:authorization_codes_get) }
    end
  end
end
