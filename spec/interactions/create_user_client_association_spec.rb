require 'spec_helper'

describe CreateUserClientAssociation do
  describe :between do
    let(:user) { Fabricate(:user) }
    let(:client) { Fabricate(:client) }

    subject { CreateUserClientAssociation.between(user, client).reload }

    its(:class) { is_expected.to be(UserClientAssociation) }

    its(:id) { is_expected.not_to be_nil }

    its(:user) { is_expected.to eq(user) }

    its(:client) { is_expected.to eq(client) }
  end
end
