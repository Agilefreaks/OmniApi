require 'spec_helper'

describe API::Resources::SmsMessages do
  include_context :with_authenticated_user

  describe "POST 'api/v1/sms_messages'" do
    subject { post '/api/v1/sms_messages', params.to_json, options }

    context 'with phone number and content' do
      let(:params) do
        {
          phone_number: '898989',
          content: 'I am hot!',
          contact_id: 42,
          type: 'outgoing',
          state: 'sending' }
      end

      it 'will call SendSms with correct params' do
        params[:access_token] = access_token.token
        expect(Sms).to receive(:with).with(params)
        subject
      end
    end

    context 'with phone_number_list and content_list' do
      let(:params) do
        {
          phone_number_list: %w(1234 123141),
          content_list: ['First template', 'Second template'],
          type: 'outgoing',
          state: 'sending'
        }
      end

      it 'will call SendSms with correct params' do
        params[:access_token] = access_token.token
        expect(Sms).to receive(:with).with(params)
        subject
      end
    end
  end

  describe "GET 'api/v1/sms_messages/:id'" do
    subject { get '/api/v1/sms_messages/5494468a63616c6cfb000000', '', options }

    before do
      Fabricate(:sms_message, user: user, id: BSON::ObjectId.from_string('5494468a63616c6cfb000000'))
    end

    it 'will return the sms message' do
      subject
      expect(last_response).to be_ok
    end
  end
end
