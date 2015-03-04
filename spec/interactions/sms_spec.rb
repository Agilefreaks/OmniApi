require 'spec_helper'

describe Sms do
  describe :with do
    include_context :with_authenticated_user

    let(:sms) { Sms.new(params) }
    let(:notification_service) { double(NotificationService) }
    let(:params) do
      {
        access_token: access_token.token,
        phone_number_list: %w(898989 123),
        content: '1',
        device_id: '42',
        state: state,
        type: type
      }
    end

    before do
      sms.notification_service = notification_service
    end

    subject { sms.execute }

    context 'with type outgoing, state sent' do
      let(:type) { 'outgoing' }
      let(:state) { 'sending' }

      before do
        allow(notification_service).to receive(:send_sms_message_requested)
      end

      it 'will call send_sms_message_requested on notification service' do
        expect(notification_service).to receive(:send_sms_message_requested).with(an_instance_of(SmsMessage), '42')
        subject
      end

      its(:content) { is_expected.to eq '1' }

      its(:state) { is_expected.to eq 'sending' }
    end

    context 'with type incoming, state received' do
      let(:type) { 'incoming' }
      let(:state) { 'received' }

      it 'will call send_sms_message_requested on notification service' do
        expect(notification_service).to receive(:sms_message_received).with(an_instance_of(SmsMessage), '42')
        subject
      end
    end
  end
end
