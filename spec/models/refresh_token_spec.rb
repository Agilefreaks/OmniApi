require 'spec_helper'

describe RefreshToken do
  it_behaves_like :oauth_token

  it { should be_embedded_in(:access_token) }
end
