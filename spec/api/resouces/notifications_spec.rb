require 'spec_helper'

describe API::Resources::Notifications do
  include_context :with_authentificated_user

  describe 'POST /api/v1/notifications' do
    let(:params) { { identifier: '42', type: :incoming_call, incoming_call: { phone_number: '0745857479' } } }

    subject { post '/api/v1/notifications', params.to_json, options }

    it 'will call CreateNotification.with the right params' do
      expect(CreateNotification).to receive(:with).with(params.merge(access_token: access_token.token))
      subject
      expect(last_response.status).to eq 201
    end
  end

  describe 'GET /api/v1/notification/:id' do
    subject { get '/api/v1/notifications', '', options }

    it 'will call FindNotification for' do
      expect(FindNotification).to receive(:for).with(access_token.token)
      subject
    end
  end
end
