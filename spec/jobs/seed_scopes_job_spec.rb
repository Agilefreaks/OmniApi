require 'spec_helper'

describe SeedScopesJob do
  let(:instance) { SeedScopesJob.new }

  describe 'perform' do
    subject { instance.perform }

    it 'seeds application Scopes' do
      subject

      expect(Scope.count).to eq(SeedScopesJob::AVAILABLE_SCOPES.size)
    end
  end
end
