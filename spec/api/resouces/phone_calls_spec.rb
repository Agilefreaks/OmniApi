require 'spec_helper'

describe API::Resources::PhoneCalls do
  include_context :with_authenticated_user

  describe "POST 'api/v1/phone_calls'" do
    let(:params) { { phone_number: '898989', device_id: '42', state: :initiate } }

    subject { post '/api/v1/phone_calls', params.to_json, options }

    it 'will call Call with the correct params' do
      expected_params = { access_token: access_token.token, phone_number: '898989', device_id: '42', state: :initiate }
      expect(Call).to receive(:with).with(expected_params)
      subject
    end
  end

  describe "PATCH 'api/v1/phone_calls/[:id]'" do
    let(:phone_call) { Fabricate(:phone_call, user: user) }
    let(:params) { { state: :end_call } }

    subject { patch "/api/v1/phone_calls/#{phone_call.id}", params.to_json, options }

    it 'will call EndCall with the right params' do
      expected_params = { access_token: access_token.token, id: phone_call.id.to_s, state: :end_call }
      expect(EndCall).to receive(:with).with(expected_params)
      subject
    end
  end

  describe "GET 'api/v1/phone_calls/[:id]'" do
    let(:phone_call) { Fabricate(:phone_call, user: user, number: '123') }
    let(:params) { { state: :end_call } }

    before do
      get "/api/v1/phone_calls/#{phone_call.id}", '', options
    end

    subject { JSON.parse(last_response.body) }

    its(['number']) { is_expected.to eq '123' }
  end
end
