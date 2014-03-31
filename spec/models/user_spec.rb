require 'spec_helper'

describe User do
  it { should embed_many(:access_tokens) }
  it { should embed_many(:authorization_codes) }

  describe :find_by_code do
    let(:user) { Fabricate(:user) }

    before do
      user.authorization_codes.create(code: 42)
    end

    subject { User.find_by_code(code) }

    context 'with valid code' do
      let(:code) { '42' }

      it { should == user }
    end

    context 'with invalid code' do
      let(:code) { '43' }

      it { should be_nil }
    end
  end
end
