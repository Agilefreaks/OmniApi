require 'spec_helper'

shared_examples :oauth_token do
  class TestToken
    include Mongoid::Document
    include Concerns::OAuth2Token
  end

  it { should have_field(:token) }
  it { should have_field(:expires_at) }

  it { should validate_presence_of(:token) }

  describe :build do
    subject { TestToken.build('42') }

    its(:token) { should_not be_nil }

    its(:expires_at) { should == Date.current + Concerns::OAuth2Token::DEFAULT_EXPIRATION_TIME }

    its(:client_id) { should == '42' }
  end
end
