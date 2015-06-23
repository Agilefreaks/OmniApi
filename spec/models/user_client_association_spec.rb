require 'spec_helper'

describe UserClientAssociation do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:client) }
  it { is_expected.to embed_many(:scopes) }
end
