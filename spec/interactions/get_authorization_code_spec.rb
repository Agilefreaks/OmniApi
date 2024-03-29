require 'spec_helper'

describe GetAuthorizationCode do
  describe :for do
    let!(:user) { Fabricate(:user, email: 'igot@this.fe') }

    subject { GetAuthorizationCode.for(email) }

    context 'when the user has an authorization code' do
      let(:email) { 'igot@this.fe' }
      let(:authorization_code) { user.authorization_codes.create }

      its(:code) { is_expected.to eq authorization_code.code }
    end

    context 'when the user has no authorization code' do
      let(:email) { 'igot@this.fe' }

      it { should_not be_nil }
    end

    context 'when wrong email' do
      let(:email) { 'tutu@durara.du' }

      it 'will throw a document not found error' do
        expect { subject }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
  end

  describe :for_emails do
    let(:user) { Fabricate(:user, email: 'eyes@dream.com') }

    subject { GetAuthorizationCode.for_emails(emails) }

    context 'when one email matches and it has an authorization active code' do
      let(:emails) { %w(eyes@dream.com some@other.com) }
      let(:authorization_code) { user.authorization_codes.create }

      before do
        authorization_code.reload
      end

      it { is_expected.to eq authorization_code }
    end

    context 'when no email matches' do
      let(:emails) { %w(no@match.com) }

      it { is_expected.to be_a EmptyAuthorizationCode }

      its(:emails) { is_expected.to eq emails }
    end

    context 'when email matches but no active authorization code' do
      let(:emails) { %w(eyes@dream.com some@other.com) }

      it 'will return a EmptyAuthorizationCode' do
        expect(subject).to be_a EmptyAuthorizationCode
      end
    end
  end
end
