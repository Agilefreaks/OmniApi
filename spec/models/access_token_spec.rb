require 'spec_helper'

describe AccessToken do
  it_behaves_like :oauth_token

  it { should be_embedded_in(:client) }
  it { should be_embedded_in(:user) }
  it { should embed_one(:refresh_tokens) }

  describe :to_bearer_token do
    let(:access_token) { AccessToken.new(token: '42', expires_in: 15.minutes) }

    subject { access_token.to_bearer_token }

    its(:access_token) { should == '42' }
    its(:expires_in) { should == 15.minutes }
  end
end
