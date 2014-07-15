require 'spec_helper'

describe CreateEvent do
  include_context :with_authentificated_user

  describe :with do
    let(:event_factory) { double(EventFactory) }
    let(:notification_service) { double(NotificationService) }
    let(:create_event) do
      CreateEvent.new(
        access_token: access_token.token,
        identifier: '42',
        type: :incoming_call,
        incoming_call: { phone_number: '0745857479' })
    end

    before do
      create_event.event_factory = event_factory
      create_event.notification_service = notification_service

      allow(event_factory).to receive(:create)
      allow(notification_service).to receive(:notify)
    end

    subject { create_event.create }

    it 'will create a new notification for the user' do
      expect(event_factory).to receive(:create)
                                      .with(:incoming_call, phone_number: '0745857479', identifier: '42')
      subject
    end

    it 'will push out a new notification' do
      expect(notification_service).to receive(:notify)
      subject
    end
  end
end
