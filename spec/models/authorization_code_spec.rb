require 'spec_helper'

describe AuthorizationCode do
  it { should have_field(:code) }
  it { should have_field(:expires_in) }

  it { should be_embedded_in(:user) }

  it { should validate_presence_of(:code) }
end
