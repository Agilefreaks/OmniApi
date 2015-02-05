require 'spec_helper'

describe FindContacts do
  include_context :with_authenticated_user

  describe :for do
    let(:params) { [access_token.token] }
    subject { FindContacts.for(*params) }

    context 'the current user has at least one contact' do
      let(:contact1) { Fabricate(:contact, user: user) }

      it { is_expected.to include(contact1) }

      context 'a second parameter is given representing a specific time' do
        let(:from_time) { Time.new(2015, 1, 1, 1, 0, 0) }
        before { params.push(from_time) }

        context 'a contact was updated after the given time' do
          before { contact1.update_attribute(:updated_at, from_time + 1.minute) }

          it  { is_expected.to include(contact1) }
        end

        context 'a contact was updated before the given time' do
          before { contact1.update_attribute(:updated_at, from_time - 1.minute) }

          it  { is_expected.to_not include(contact1) }
        end

        describe 'contacts updated before the given time' do
          let(:old_contacts) { subject.select { |contact| contact.updated_at < from_time } }

          its(:length) { is_expected.to eq(0) }
        end
      end
    end

    context 'at least another user exists in the db' do
      let(:user2) { Fabricate(:user) }

      context 'the second user has at least one contact' do
        let(:contact2) { Fabricate(:contact, user: user2) }

        it { is_expected.to_not include(contact2) }
      end
    end
  end
end
