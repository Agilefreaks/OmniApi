require 'spec_helper'

describe API::Resources::OAuth2 do
  let(:client) { Fabricate(:client) }
  let(:client_id) { client.id }
  let(:params) { Hash[:grant_type, grant_type, :client_id, client_id] }

  shared_examples_for 'oauth2 grant type' do
    subject { last_response }

    context 'and it has a valid params' do
      before :each do
        post '/api/v1/oauth2/token.json', valid_params
      end

      its(:status) { should == 200 }

      its(:body) { should include('access_token') }
    end

    context 'and it has an invalid params' do
      before :each do
        post '/api/v1/oauth2/token', invalid_params
      end

      its(:status) { should == 400 }

      its(:body) { should have_json_path('error') }

      its(:body) { should have_json_path('error_description') }
    end
  end

  shared_examples_for 'contains refresh_token' do
    subject { last_response }

    context 'and it has a valid params' do
      before :each do
        post '/api/v1/oauth2/token', valid_params
      end

      its(:body) { should have_json_path('refresh_token') }
    end
  end

  context 'when grant type is authorization_code' do
    let(:grant_type) { :authorization_code }
    let(:valid_params) { params.merge(code: '43') }

    before do
      user = Fabricate(:user)
      user.authorization_codes.create(code: '43')
    end

    it_behaves_like 'oauth2 grant type' do
      let(:invalid_params) { params.merge(code: '44') }
    end

    it_behaves_like 'contains refresh_token'
  end

  context 'when grant type is refresh_token' do
    let(:grant_type) { :refresh_token }
    let(:access_token) { AccessToken.build(client_id) }

    before do
      user = Fabricate(:user)
      access_token.refresh_token = RefreshToken.build(client_id)
      user.access_tokens.push(access_token)
      user.save
    end

    it_behaves_like 'oauth2 grant type' do
      let(:valid_params) { params.merge(refresh_token: access_token.refresh_token.token) }
      let(:invalid_params) { params.merge(refresh_token: 'i123') }
    end
  end

  context 'when grant type is client_credentials' do
    let(:grant_type) { :client_credentials }
    let(:valid_params) { params.merge(client_secret: client.secret) }
    before { params['resource_type'] = :client }

    it_behaves_like 'oauth2 grant type' do
      let(:invalid_params) { params.merge(client_secret: 'not secret') }
    end

    it_behaves_like 'contains refresh_token'
  end

  context 'when grant type is invalid' do
    let(:grant_type) { :invalid }

    before :each do
      post '/api/v1/oauth2/token', params
    end

    subject { last_response }

    its(:status) { should == 400 }

    its(:body) { should have_json_path('error') }
  end
end
