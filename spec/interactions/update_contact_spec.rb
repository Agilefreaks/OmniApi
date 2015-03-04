require 'spec_helper'

describe UpdateContact do
  include_context :with_authenticated_user

  describe :with do
    let!(:contact) { Fabricate(:contact, user: user, name: 'Ion') }

    subject { UpdateContact.with(access_token: access_token.token, id: contact.id.to_s, name: 'Ionica') }

    its(:name) { is_expected.to eq 'Ionica' }

    it 'will call Notification service contact updated' do
      expect_any_instance_of(NotificationService).to receive(:contact_updated).with(contact, nil)
      subject
    end
  end
end
