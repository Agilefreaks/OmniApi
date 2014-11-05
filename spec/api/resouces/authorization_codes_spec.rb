require 'spec_helper'

describe API::Resources::Users do
  describe 'POST /authorization_codes' do
    include_context :with_authenticated_web_client

    let(:authorization_code) { AuthorizationCode.new }
    let(:params) { { email: 'come@home.com' } }

    subject { post 'api/v1/authorization_codes', params.to_json, options }

    before do
      allow(GetAuthorizationCode).to receive(:for).with('come@home.com').and_return(authorization_code)
    end

    it 'will return the existing one' do
      subject
      expect(last_response.body).to eq API::Entities::AuthorizationCode.new(authorization_code).to_json
    end
  end

  describe 'GET /authorization_codes' do
    include_context :with_authenticated_android_client

    let(:params) { %w(spread@wings.com take@yourtime.com love@thesky.com) }

    subject { get "api/v1/authorization_codes?#{params.to_query(:emails)}", {}, options }

    before do
      allow(GetAuthorizationCode).to receive(:for_emails).with(params).and_return(authorization_code)
    end

    context 'when there is a authorization code' do
      let(:authorization_code) { AuthorizationCode.new }

      it 'will return the authorization code' do
        subject
        expect(last_response.body).to eq API::Entities::AuthorizationCode.new(authorization_code).to_json
      end
    end

    context 'when there is no authorization code' do
      let(:authorization_code) { EmptyAuthorizationCode.new }

      it 'will raise a 404' do
        expect(subject.status).to eq 404
      end
    end
  end
end
