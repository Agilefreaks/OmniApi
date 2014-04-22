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
      'ACCEPT' => 'application/json'
    }
  }

  describe 'GET /users' do

  end

  describe 'POST /users' do
    let(:params) { { email: 'some@user.com', providers: [] } }

    subject { post '/api/v1/users', params.to_json, options }

    it 'will create user' do
      expect { subject }.to change(User, :count).by(1)
    end
  end
end