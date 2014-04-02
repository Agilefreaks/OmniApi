require 'spec_helper'

describe API::Resources::Phones do
  include Rack::Test::Methods

  def app
    OmniApi::App.instance
  end

  let(:access_token) { '42' }
  let(:options) {
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'HTTP_AUTHORIZATION' => 'bearer 42' }
  }

  describe "POST 'api/v1/phones/call'" do
    include_context :with_authentificated_user

    let(:params) { { :'phone_number' => '898989' } }

    it 'will call Call.device with the correct params' do
      expect(Call).to receive(:with).with(access_token: access_token, phone_number: '898989')
      post '/api/v1/phones/call', params.to_json, options
    end
  end
end