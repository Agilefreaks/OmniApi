require 'spec_helper'

describe API::Resources::Phones do
  include_context :with_authentificated_user

  describe "POST 'api/v1/phones/call'" do
    let(:params) { { phone_number: '898989' } }

    it 'will call Call.device with the correct params' do
      expect(Call).to receive(:with).with(access_token: access_token.token, phone_number: '898989')
      post '/api/v1/phones/call', params.to_json, options
    end
  end

  describe "POST 'api/v1/phones/end_call'" do
    it 'will call EndCall.with' do
      expect(EndCall).to receive(:with).with(access_token: access_token.token)
      post '/api/v1/phones/end_call', nil, options
    end
  end

  describe "POST 'api/v1/phones/sms'" do
    let(:params) { { phone_number: '898989', content: 'I am hot!' } }

    it 'will call Call.device with the correct params' do
      expect(Sms).to receive(:with).with(access_token: access_token.token, phone_number: '898989', content: 'I am hot!')
      post '/api/v1/phones/sms', params.to_json, options
    end
  end
end
