require 'spec_helper'

describe SendSmsMessage do
  describe :with do
    include_context :with_authenticated_user

    subject { SendSmsMessage.with(params) }

    context 'with phone_number and content' do
      let(:params) { { access_token: access_token.token, phone_number: '898989', content: 'I am to see you!' } }

      it 'will create a new sms message' do
        expect { subject }.to change(user.sms_messages, :count).by(1)
      end

      it 'will call sms on notification service' do
        expect_any_instance_of(NotificationService).to receive(:sms)
        subject
      end
    end

    context 'with phone_number_list and content_list' do
      let(:params) { { access_token: access_token.token, phone_number_list: %w(898989 123), content: '1' } }

      it 'will create a new sms message' do
        expect { subject }.to change(user.sms_messages, :count).by(1)
      end

      it 'will call sms_message on notification service' do
        expect_any_instance_of(NotificationService).to receive(:sms_message)
        subject
      end
    end
  end
end
