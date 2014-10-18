require 'spec_helper'

shared_examples :oauth_token do
  class TestToken
    include Mongoid::Document
    include Concerns::OAuth2Token
  end

  it { should have_field(:token) }
  it { should have_field(:expires_at) }

  it { should validate_presence_of(:token) }

  describe :is_expired? do
    subject(:access_token) { TestToken.new(token: '42', expires_at: expires_at) }

    context 'when expired_at before today' do
      let(:expires_at) { Time.now.utc - 1.day }

      its(:is_expired?) { is_expected.to be_falsey }
    end

    context 'when expired_at after today' do
      let(:expires_at) { Time.now.utc + 1.day }

      its(:is_expired?) { is_expected.to be_truthy }
    end
  end

  describe :build do
    subject { TestToken.build('42') }

    its(:token) { is_expected.not_to be_nil }

    its(:'expires_at.to_i') { is_expected.to eq (Time.now.utc + Concerns::OAuth2Token::DEFAULT_EXPIRATION_TIME).to_i }

    its(:client_id) { is_expected.to eq '42' }
  end
end
