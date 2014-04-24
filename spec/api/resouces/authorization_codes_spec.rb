require 'spec_helper'

describe API::Resources::Users do
  include Rack::Test::Methods

  def app
    OmniApi::App.instance
  end

  # rubocop:disable Blocks
  let(:options) {
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => "bearer #{access_token.token}"
    }
  }

  describe 'POST /authorization_codes' do
    include_context :with_authentificated_client

    let(:authorization_code) { AuthorizationCode.new }
    let(:params) { { user_id: '42' } }

    subject { post 'api/v1/authorization_codes', params.to_json, options }

    before do
      allow(GetAuthorizationCode).to receive(:for).with('42').and_return(authorization_code)
    end

    it 'will return the existing one' do
      subject
      expect(last_response.body).to eq API::Entities::AuthorizationCode.new(authorization_code).to_json
    end
  end
end
