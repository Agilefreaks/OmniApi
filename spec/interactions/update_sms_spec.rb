require 'spec_helper'

describe UpdateSms do
  include_context :with_authenticated_user

  describe :with do
    let(:params) do
      {
        access_token: access_token.token,
        state: 'sent',
        type: 'outgoing',
        id: id,
        device_id: 'device_id'
      }
    end

    subject { UpdateSms.with(params) }

    context 'for an existing sms' do
      let(:sms_message) { Fabricate(:sms_message, user: user, state: 'sending') }
      let(:id) { sms_message.id }

      its(:state) { is_expected.to eq 'sent' }

      it 'will send a notification' do
        expect_any_instance_of(NotificationService).to receive(:sms_message_delivered).with(sms_message, 'device_id')
        subject
      end
    end
  end
end
