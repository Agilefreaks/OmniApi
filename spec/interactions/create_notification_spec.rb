require 'spec_helper'

describe CreateNotification do
  include_context :with_authentificated_user

  describe :with do
    let(:notification_factory) { double(NotificationFactory) }
    let(:notification_service) { double(NotificationService) }
    let(:create_notification) do
      CreateNotification.new(
        access_token: access_token.token,
        identifier: '42',
        type: :incoming_call,
        incoming_call: { phone_number: '0745857479' })
    end

    before do
      create_notification.notification_factory = notification_factory
      create_notification.notification_service = notification_service

      allow(notification_factory).to receive(:create)
      allow(notification_service).to receive(:notify)
    end

    subject { create_notification.create }

    it 'will create a new notification for the user' do
      expect(notification_factory).to receive(:create)
                                      .with(:incoming_call, phone_number: '0745857479', identifier: '42')
      subject
    end

    it 'will push out a new notification' do
      expect(notification_service).to receive(:notify)
      subject
    end
  end
end
