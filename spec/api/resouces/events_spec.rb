require 'spec_helper'

describe API::Resources::Events do
  include_context :with_authentificated_user

  describe 'POST /api/v1/events' do
    subject { post '/api/v1/events', params.to_json, options }

    context 'when incoming call' do
      let(:params) { { identifier: '42', type: :incoming_call, incoming_call: { phone_number: '0745857479' } } }

      it 'will call CreateEvent.with the right params' do
        expect(CreateEvent).to receive(:with).with(params.merge(access_token: access_token.token))
        subject
        expect(last_response.status).to eq 201
      end
    end

    context 'when incoming sms' do
      let(:params) { { identifier: '42', type: :incoming_sms, incoming_sms: { phone_number: '0745857479', content: 'some content' } } }

      it 'will call CreateEvent.with the right params' do
        expect(CreateEvent).to receive(:with).with(params.merge(access_token: access_token.token))
        subject
        expect(last_response.status).to eq 201
      end
    end
  end

  describe 'GET /api/v1/events/:id' do
    subject { get '/api/v1/events', '', options }

    it 'will call FindEvent for' do
      expect(FindEvent).to receive(:for).with(access_token.token)
      subject
    end
  end
end
