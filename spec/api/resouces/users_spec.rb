require 'spec_helper'

describe API::Resources::Users do
  include_context :with_authenticated_client

  describe 'POST /users' do
    let(:params) { { email: 'some@user.com' } }

    subject { post '/api/v1/users', params.to_json, options }

    it 'will create user' do
      expect { subject }.to change(User, :count).by(1)
    end
  end
end
