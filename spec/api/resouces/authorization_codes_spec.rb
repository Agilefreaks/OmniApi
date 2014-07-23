require 'spec_helper'

describe API::Resources::Users do
  describe 'POST /authorization_codes' do
    include_context :with_authenticated_web_client

    let(:authorization_code) { AuthorizationCode.new }
    let(:params) { { user_access_token: '42' } }

    subject { post 'api/v1/authorization_codes', params.to_json, options }

    before do
      allow(GetAuthorizationCode).to receive(:for).with('42').and_return(authorization_code)
    end

    it 'will return the existing one' do
      subject
      expect(last_response.body).to eq API::Entities::AuthorizationCode.new(authorization_code).to_json
    end
  end

  describe 'GET /authorization_codes' do
    include_context :with_authenticated_android_client

    let(:authorization_code) { AuthorizationCode.new }
    let(:params) { { emails: %w(spread@wings.com take@yourtime.com love@thesky.com) } }

    subject { get "api/v1/authorization_codes?#{params.to_query}", {}, options }

    before do
      allow(GetAuthorizationCode).to receive(:for_emails).with(params[:emails]).and_return(authorization_code)
    end

    it 'will return the existing one' do
      subject
      expect(last_response.body).to eq API::Entities::AuthorizationCode.new(authorization_code).to_json
    end
  end
end
