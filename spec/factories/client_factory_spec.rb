require 'spec_helper'

describe :ClientFactory do
  describe :create_web_client do
    let(:id) { BSON::ObjectId.new }
    subject { ClientFactory.create_web_client(id) }

    its(:name) { is_expected.to eq 'WebClient' }
    its(:_id) { is_expected.to eq id }
    its('access_tokens.count') { is_expected.to eq 1 }
    its('access_tokens.first.scopes') { is_expected.to eq ScopesRepository.get(:web_client) }
  end

  describe :create_android_client do
    subject { ClientFactory.create_android_client }

    its(:name) { is_expected.to eq 'AndroidClient' }
    its('access_tokens.count') { is_expected.to eq 1 }
    its('access_tokens.first.scopes') { is_expected.to eq ScopesRepository.get(:android_client) }
  end

  describe :create_win_client do
    subject { ClientFactory.create_win_client }

    its(:name) { is_expected.to eq 'WinClient' }
    its('access_tokens.count') { is_expected.to eq 1 }
    its('access_tokens.first.scopes') { is_expected.to eq ScopesRepository.get(:win_client) }
  end
end
