require 'spec_helper'

describe Sms::Update do
  describe :with do
    let(:params) do
      {
        access_token: access_token.token,
        type: 'outgoing',
        id: id,
        device_id: 'device_id'
      }
    end

    subject { Sms::Update.with(params) }

    context 'for a sms that is in sending state' do
      include_context :with_authenticated_user

      let(:sms_message) { Fabricate(:sms_message, user: user, state: 'sending') }
      let(:id) { sms_message.id }

      before do
        params[:state] = 'sent'
      end

      its(:state) { is_expected.to eq 'sent' }

      it 'will send a notification' do
        expect_any_instance_of(NotificationService).to receive(:sms_message_sent).with(sms_message, 'device_id')
        subject
      end
    end

    context 'for a scheduled sms' do
      include_context :with_authenticated_omnikiq_client
      let(:sms_message) { Fabricate(:sms_message, state: 'scheduled') }
      let(:id) { sms_message.id }
      let(:notification_service) { double(NotificationService) }

      before do
        params[:state] = 'sending'
        allow(NotificationService).to receive(:new).and_return(notification_service)
        allow(notification_service).to receive(:send_sms_message_requested)
      end

      its(:state) { is_expected.to eq 'sending' }

      it 'will send a notification' do
        expect(notification_service).to receive(:send_sms_message_requested).with(sms_message, 'device_id')

        subject
      end
    end
  end
end
