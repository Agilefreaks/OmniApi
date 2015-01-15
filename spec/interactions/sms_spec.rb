require 'spec_helper'

describe Sms do
  describe :with do
    include_context :with_authenticated_user

    let(:sms) { Sms.new(Sms::SmsMessageParams.new(params)) }
    let(:notification_service) { double(NotificationService) }

    before do
      sms.notification_service = notification_service
    end

    subject { sms.execute }

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
        expect(notification_service).to receive(:notify)
        expect { subject }.to change(user.sms_messages, :count).by(1)
      end
    end
  end
end
