require 'spec_helper'

describe ContactListBuilder do
  include_context :with_authenticated_user

  describe :build do
    let(:contacts) { 'some cryptic contacts' }

    subject { ContactListBuilder.new.build(access_token.token, identifier, contacts) }

    context 'for a new identifier' do
      let(:identifier) { 'never seen before' }

      its(:contacts) { is_expected.to eq contacts }
    end

    context 'for an existing identifier' do
      let(:identifier) { 'exiting one' }

      before do
        Fabricate(:contact_list, identifier: identifier, contacts: 'old cryptic contacts', user: user)
      end

      its(:contacts) { is_expected.to eq contacts }

      it 'will not duplicate identifiers' do
        subject
        user.reload
        expect(user.contact_lists.count).to eq 1
      end
    end
  end
end
