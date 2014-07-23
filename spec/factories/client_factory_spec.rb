require 'spec_helper'

describe :ClientFactory do
  describe :create_web_client do
    subject { ClientFactory.create_web_client }

    its(:name) { is_expected.to eq 'WebClient' }
    its('access_tokens.count') { is_expected.to eq 1 }
    its('access_tokens.first.roles') { is_expected.to eq RolesRepository.get(:web_client) }
  end

  describe :create_android_client do
    subject { ClientFactory.create_android_client }

    its(:name) { is_expected.to eq 'AndroidClient' }
    its('access_tokens.count') { is_expected.to eq 1 }
    its('access_tokens.first.roles') { is_expected.to eq RolesRepository.get(:android_client) }
  end

  describe :create_win_client do
    subject { ClientFactory.create_win_client }

    its(:name) { is_expected.to eq 'WinClient' }
    its('access_tokens.count') { is_expected.to eq 1 }
    its('access_tokens.first.roles') { is_expected.to eq RolesRepository.get(:win_client) }
  end
end
