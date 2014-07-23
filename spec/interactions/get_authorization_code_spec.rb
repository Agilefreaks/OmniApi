require 'spec_helper'

describe GetAuthorizationCode do
  describe :for do
    let(:user) { Fabricate(:user) }
    let(:token) { user.access_tokens.last.token }

    before do
      GenerateOauthToken.build_access_token_for(user, '43')
    end

    subject { GetAuthorizationCode.for(token) }

    context 'when the user has an authorization code' do
      let(:authorization_code) { user.authorization_codes.create }

      before do
        authorization_code.reload
      end

      it { is_expected.to eq authorization_code }
    end

    context 'when the user has no authorization code' do
      it { should_not be_nil }
    end

    context 'when wrong access_token' do
      let(:token) { 'other' }

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

      it 'will throw a 404' do
        expect { subject }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    context 'when email matches but no active authorization code' do
      let(:emails) { %w(eyes@dream.com some@other.com) }

      it 'will throw a 404' do
        expect { subject }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
  end
end
