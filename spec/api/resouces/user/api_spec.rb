require 'spec_helper'

describe API::Resources::User::Api do
  include_context :with_authenticated_client

  describe "GET '/api/v1/user'" do
    include_context :with_authenticated_user

    before do
      get '/api/v1/user', '', options
    end

    subject { last_response }

    it { is_expected.to be_ok }
  end
end
