require 'spec_helper'

describe CreateContactList do
  include_context :with_authenticated_user

  let(:service) { CreateContactList.new(access_token: access_token.token, identifier: '42', contacts: 'some') }

  describe :create do
    let(:contact_list_builder) { double(ContactListBuilder) }
    let(:notification_service) { double(NotificationService) }
    let(:contact_list) { ContactList.new }

    before do
      service.contact_list_builder = contact_list_builder
      service.notification_service = notification_service

      allow(contact_list_builder).to receive(:build).and_return(contact_list)
      allow(notification_service).to receive(:notify)
    end

    subject { service.create }

    it 'will call build on builder with the correct params' do
      expect(contact_list_builder).to receive(:build).with(access_token.token, '42', 'some')
      subject
    end

    it 'will call notify with the correct params' do
      expect(notification_service).to receive(:notify).with(contact_list, '42')
      subject
    end
  end
end
