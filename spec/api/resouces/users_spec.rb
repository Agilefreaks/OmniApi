require 'spec_helper'

describe API::Resources::Users do
  include_context :with_authentificated_client

  describe 'GET /users/:id' do
    let!(:user) { Fabricate(:user, _id: '42') }

    subject { get '/api/v1/users/42', '', options }

    it 'will fetch user' do
      subject
      expect(last_response.body).to eq API::Entities::User.new(user).to_json
    end
  end

  describe 'POST /users' do
    let(:params) { { email: 'some@user.com', providers: [] } }

    subject { post '/api/v1/users', params.to_json, options }

    it 'will create user' do
      expect { subject }.to change(User, :count).by(1)
    end
  end
end
