require 'spec_helper'

describe CreateUserClientAssociation do
  describe :between do
    let(:user) { Fabricate(:user) }
    let(:client_scope) { Fabricate(:scope, key: :phone_calls_create) }
    let(:client) { Fabricate(:client, scopes: [client_scope]) }

    subject { CreateUserClientAssociation.between(user, client).reload }

    its(:class) { is_expected.to be(UserClientAssociation) }

    its(:id) { is_expected.not_to be_nil }

    its(:user) { is_expected.to eq(user) }

    its(:client) { is_expected.to eq(client) }

    its(:scopes) { is_expected.to eq([client_scope]) }

    its(:access_token) { is_expected.not_to be_nil }

    it 'adds access_token to user' do
      result = subject

      expect(user.reload.access_tokens.last.token).to eq(result.access_token.token)
    end

    it 'sets scopes on token' do
      result = subject

      expect(result.access_token.scopes).to eq([:phone_calls_create])
    end
  end
end
