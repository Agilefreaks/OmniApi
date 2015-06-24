require 'spec_helper'

describe API::Entities::User do
  include_context :with_authenticated_user

  subject { JSON.parse(API::Entities::User.new(user).to_json) }

  context 'when contacts_updated_at is nil' do
    before do
      user.contacts_updated_at = nil
    end

    it 'will not be exposed' do
      expect(subject['contacts_updated_at']).to be_nil
    end
  end

  context 'when contacts_updated_at is not nil' do
    before do
      user.contacts_updated_at = Date.today
    end

    it 'will be exposed' do
      expect(subject['contacts_updated_at']).to eq user.contacts_updated_at.iso8601
    end
  end
end
