require 'spec_helper'

describe CreateUserClientAssociation do
  describe :between do
    let(:user) { Fabricate(:user) }
    let(:client_scope) { Fabricate(:scope) }
    let(:client) { Fabricate(:client, scopes: [client_scope]) }

    subject { CreateUserClientAssociation.between(user, client).reload }

    its(:class) { is_expected.to be(UserClientAssociation) }

    its(:id) { is_expected.not_to be_nil }

    its(:user) { is_expected.to eq(user) }

    its(:client) { is_expected.to eq(client) }

    its(:scopes) { is_expected.to eq([client_scope]) }
  end
end
