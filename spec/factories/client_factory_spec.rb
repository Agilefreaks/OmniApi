require 'spec_helper'

describe :ClientFactory do
  shared_examples_for 'a client' do |expected_name, expected_scope|
    its(:name) { is_expected.to eq expected_name }
    its('access_tokens.count') { is_expected.to eq 1 }
    its(:'access_tokens.first.scopes') { is_expected.to eq expected_scope }
  end

  describe :create_web_client do
    subject { ClientFactory.create_web_client }

    it_behaves_like 'a client', 'WebClient', ScopesRepository.get(:web_client)

    context 'given an id' do
      let(:id) { BSON::ObjectId.new }

      subject { ClientFactory.create_web_client(id) }

      its(:_id) { is_expected.to eq id }
      it_behaves_like 'a client', 'WebClient', ScopesRepository.get(:web_client)
    end
  end

  describe :create_android_client do
    subject { ClientFactory.create_android_client }

    it_behaves_like 'a client', 'AndroidClient', ScopesRepository.get(:android_client)
  end

  describe :create_win_client do
    subject { ClientFactory.create_win_client }

    it_behaves_like 'a client', 'WinClient', ScopesRepository.get(:win_client)
  end

  describe :create_omnikiq_client do
    subject { ClientFactory.create_omnikiq_client }

    it_behaves_like 'a client', 'OmnikiqClient', ScopesRepository.get(:omnikiq_client)
  end
end
