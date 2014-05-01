require 'spec_helper'

describe API::Resources::Notifications do
  include_context :with_authentificated_user

  describe 'POST /api/v1/notifications' do
    it 'will work' do
      post '/api/v1/notifications'
      expect(last_response.status).to eq 201
    end
  end
end