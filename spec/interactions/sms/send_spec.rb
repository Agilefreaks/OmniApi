require 'spec_helper'

describe Sms::Send do
  let!(:notification_service) { double(NotificationService) }
  let(:params) { {id: scheduled_sms_message.id, state: 'sending', device_id: 'device_id' } }
  let(:sms) { Sms::Send.new (params) }

  before do
    sms.notification_service = notification_service
    allow(notification_service).to receive(:send_sms_message_requested)
  end

  describe :send do
    let!(:scheduled_sms_message) { Fabricate(:sms_message, state: 'scheduled') }

    subject { sms.send }

    it 'changes the status of the message to sending' do
      expect { subject }.to change { SmsMessage.first.state }.from('scheduled').to('sending')
    end

    it 'calls notification service to request new sms message' do
      expect(notification_service).to receive(:send_sms_message_requested).with(SmsMessage.first, 'device_id')

      subject
    end
  end
end