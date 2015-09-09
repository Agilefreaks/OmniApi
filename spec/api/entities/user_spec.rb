require 'spec_helper'

describe API::Entities::User do
  include_context :with_authenticated_user

  let(:options) { {} }
  let(:entity) { JSON.parse(API::Entities::User.new(user, options).to_json) }

  describe 'contacts_updated_at' do
    subject { entity['contacts_updated_at'] }

    context 'is nil' do
      before do
        user.contacts_updated_at = nil
      end

      it { is_expected.to be_nil }
    end

    context 'is not nil' do
      before do
        user.contacts_updated_at = Date.today
      end

      it { is_expected.to eq user.contacts_updated_at.iso8601 }
    end
  end
end
