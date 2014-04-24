require 'spec_helper'

describe GetAuthorizationCode do
  describe :for do
    let(:user) { Fabricate(:user) }

    subject { GetAuthorizationCode.for(user.id.to_s) }

    context 'when the user has an authorization code' do
      let(:authorization_code) { user.authorization_codes.create }

      before do
        authorization_code.reload
      end

      it { should == authorization_code }
    end

    context 'when the user has no authorization code' do
      it { should_not be_nil }
    end
  end
end
