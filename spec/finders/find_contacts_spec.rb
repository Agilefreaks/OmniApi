require 'spec_helper'

describe FindContacts do
  include_context :with_authenticated_user

  describe :for do
    let(:params) { {} }
    subject { FindContacts.for(access_token.token, params) }

    context 'the current user has at least one contact' do
      let(:contact1) { Fabricate(:contact, user: user) }

      it { is_expected.to include(contact1) }

      context 'a from time is given' do
        let(:from) { Time.new(2015, 1, 1, 1, 0, 0) }
        before { params[:from] = from }

        context 'a contact was updated after the given time' do
          before { contact1.update_attribute(:updated_at, from + 1.minute) }

          it  { is_expected.to include(contact1) }
        end

        context 'a contact was updated before the given time' do
          before { contact1.update_attribute(:updated_at, from - 1.minute) }

          it  { is_expected.to_not include(contact1) }
        end

        describe 'contacts updated before the given time' do
          let(:old_contacts) { subject.select { |contact| contact.updated_at < from } }

          its(:length) { is_expected.to eq(0) }
        end
      end

      context 'a contact_id is given' do
        let(:contact_id) { 42 }
        before { params[:contact_id] = contact_id }

        context 'when there is a user with contact id' do
          before { contact1.update_attribute(:contact_id, contact_id) }

          it { is_expected.to eq contact1 }
        end

        context 'when there is no user with the contact id' do
          it 'will throw DocumentNotFound' do
            expect { subject }.to raise_error Mongoid::Errors::DocumentNotFound
          end
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
