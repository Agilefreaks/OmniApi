require 'spec_helper'

describe API::Resources::SmsMessages do
  include_context :with_authenticated_user

  describe "POST 'api/v1/sms_messages'" do
    context 'with phone number and content' do
      let(:params) { { phone_number: '898989', content: 'I am hot!' } }

      it 'will call SendSms with correct params' do
        params[:access_token] = access_token.token
        expect(SendSmsMessage).to receive(:with).with(params)
        post '/api/v1/sms_messages', params.to_json, options
      end
    end

    context 'with phone_number_list and content_list' do
      let(:params) { { phone_number_list: %w(1234 123141), content_list: ['First template', 'Second template'] } }

      it 'will call SendSms with correct params' do
        params[:access_token] = access_token.token
        expect(SendSmsMessage).to receive(:with).with(params)
        post '/api/v1/sms_messages', params.to_json, options
      end
    end
  end
end
