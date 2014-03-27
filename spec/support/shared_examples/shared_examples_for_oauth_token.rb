require 'spec_helper'

shared_examples :oauth_token do
  class TestToken
    include Mongoid::Document
    include Concerns::OAuth2Token
  end

  it { should have_field(:token) }
  it { should have_field(:expires_in) }

  describe :build do
    subject { TestToken.build }

    its(:token) { should_not be_nil }

    its(:expires_in) { should == Concerns::OAuth2Token::DEFAULT_EXPIRATION_TIME }
  end
end
