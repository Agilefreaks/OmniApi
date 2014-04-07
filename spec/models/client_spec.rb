require 'spec_helper'

describe Client do
  it { should be_timestamped_document }
  it { should have_field(:secret).of_type(String) }
  it { should embed_many(:access_tokens) }

  its(:secret) { should_not be_nil }

  describe :before_create do
    subject { Fabricate(:client) }

    its('access_tokens.count') { should == 1 }
  end
end
