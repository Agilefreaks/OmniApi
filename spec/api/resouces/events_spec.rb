require 'spec_helper'

describe API::Resources::Events do
  include_context :with_authentificated_user

  describe 'POST /api/v1/events' do
    subject { post '/api/v1/events', params.to_json, options }

    context 'when incoming call' do
      let(:incoming_call) { { phone_number: '0745857479', contact_name: 'Alice Morisset' } }
      let(:params) { { identifier: '42', type: :incoming_call, incoming_call: incoming_call } }

      it 'will call CreateEvent.with the right params' do
        expect(CreateEvent).to receive(:with).with(params.merge(access_token: access_token.token))
        subject
        expect(last_response.status).to eq 201
      end
    end

    context 'when incoming sms' do
      let(:incoming_sms) { { phone_number: '0745857479', content: 'some content', contact_name: 'Alice Morisset' } }
      let(:params) { { identifier: '42', type: :incoming_sms, incoming_sms: incoming_sms } }

      it 'will call CreateEvent.with the right params' do
        expect(CreateEvent).to receive(:with).with(params.merge(access_token: access_token.token))
        subject
        expect(last_response.status).to eq 201
      end

      it 'will return the event with content property set' do
        subject
        expect(JSON.parse(last_response.body)['content']).to eq 'some content'
      end
    end
  end

  describe 'GET /api/v1/events/:id' do
    subject { get '/api/v1/events', '', options }

    before do
      expect(FindEvent).to receive(:for).with(access_token.token).and_return(event)
    end

    context 'with IncomingSmsEvent event' do
      let(:event) { IncomingSmsEvent.new(content: 'some content', contact_name: 'Falling Star', phone_number: '123') }

      it 'will present IncomingSmsEvent' do
        subject
        expect(JSON.parse(last_response.body)['content']).to eq 'some content'
        expect(JSON.parse(last_response.body)['contact_name']).to eq 'Falling Star'
        expect(JSON.parse(last_response.body)['phone_number']).to eq '123'
        expect(JSON.parse(last_response.body)['type']).to eq 'IncomingSmsEvent'
      end
    end

    context 'with IncomingCallEvent' do
      let(:event) { IncomingCallEvent.new }

      it 'will present IncomingCallEvent' do
        subject
        expect(JSON.parse(last_response.body)['type']).to eq 'IncomingCallEvent'
      end
    end
  end
end
