require 'spec_helper'

describe API::Resources::SmsMessages do
  context 'with authenticated user' do
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
            state: 'sending'
          }
        end

        it 'will call SendSms with correct params' do
          params[:access_token] = access_token.token
          expect(Sms::Create).to receive(:with).with(params)
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
          expect(Sms::Create).to receive(:with).with(params)
          subject
        end
      end

      context 'scheduled at a later time' do
        let(:params) do
          {
            phone_number_list: %w(1234 123141),
            content_list: ['First template', 'Second template'],
            device_id: 'device_id',
            state: 'scheduled',
            scheduled_at: DateTime.now.utc + 5.minutes,
            type: 'outgoing'
          }
        end

        it 'creates a sms message' do
          expect { subject }.to change { user.sms_messages.length }.from(0).to(1)
        end

        it 'creates the message in scheduled state' do
          subject

          expect(user.sms_messages.last.state).to eq 'scheduled'
        end

        it 'creates the message with scheduled_at set correctly' do
          subject

          expect(user.sms_messages.last.scheduled_at).to be_the_same_time_as(params[:scheduled_at])
        end

        it 'creates a delayed job to send the SMS at the specified time' do
          expect(OmniKiq::Workers::SendScheduledSmsWorker).to receive(:perform_at).with(params[:scheduled_at], any_args, params[:device_id])

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

    describe "PATCH 'api/v1/sms_messages/:id'" do
      context 'for a sent message' do
        let!(:sms_message) { Fabricate(:sms_message, user: user) }
        let(:params) { { state: 'sent' } }

        subject { patch "/api/v1/sms_messages/#{sms_message.id}", { state: 'sent', type: 'outgoing' }.to_json, options }

        it 'will call update sms with the correct params' do
          expected_params = { access_token: access_token.token, id: sms_message.id.to_s, state: 'sent', type: 'outgoing' }
          expect(Sms::Update).to receive(:with).with(expected_params)

          subject
        end
      end
    end
  end

  context 'with authenticated client' do
    include_context :with_authenticated_omnikiq_client

    describe "PATCH 'api/v1/sms_messages/:id'" do
      context 'for a scheduled message' do
        let(:sms_message) { Fabricate(:sms_message, state: 'scheduled') }
        let(:params) { { state: 'sending' } }
        let(:notification_service) { double(NotificationService) }

        before do
          allow(NotificationService).to receive(:new).and_return(notification_service)
          allow(notification_service).to receive(:send_sms_message_requested)
        end

        subject { patch "/api/v1/sms_messages/#{sms_message.id}", { state: 'sending', type: 'outgoing'}.to_json, options }

        it 'will call send sms with correct params' do
          expect { subject }.to change { SmsMessage.find(sms_message.id).state }.from('scheduled').to('sending')
        end
      end
    end
  end
end
