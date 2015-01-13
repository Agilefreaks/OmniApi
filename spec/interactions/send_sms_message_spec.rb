require 'spec_helper'

describe Sms do
  describe :with do
    include_context :with_authenticated_user

    subject { Sms.with(params) }

    context 'with phone_number_list and content_list' do
      let(:params) do
        {
          access_token: access_token.token,
          phone_number_list: %w(898989 123),
          state: :incoming,
          content: '1',
          device_id: '42'
        }
      end

      it 'will create a new sms message' do
        expect { subject }.to change(user.sms_messages, :count).by(1)
      end

      it 'will call sms_message on notification service' do
        expect_any_instance_of(NotificationService).to receive(:incoming_sms_message)
        subject
      end
    end
  end
end
