require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }

  it { should embed_many(:access_tokens) }
  it { should embed_many(:authorization_codes) }
  it { should embed_many(:registered_devices) }
  it { should embed_many(:clippings) }

  describe :find_by_code do
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

  describe :find_by_token do
    let(:client_id) { '42' }
    let(:access_token) { AccessToken.build('42') }
    let(:refresh_token) { RefreshToken.build('42') }

    before do
      access_token.refresh_token = refresh_token
      user.access_tokens.push(access_token)
      user.save
    end

    subject { User.find_by_token(token) }

    context 'with valid token' do
      let(:token) { access_token.token }

      it { should == user }
    end

    context 'with invalid token' do
      let(:token) { 'invalid token' }

      it { should be_nil }
    end

    context 'with valid refresh token' do
      let(:token) { refresh_token.token }

      it { should == user }
    end

    context 'with expired token' do
      let(:token) { access_token.token }

      before do
        user.access_tokens.first.update(expires_at: Date.current - 1.month)
        user.save
      end

      it { should be_nil }
    end
  end

  describe :invalidate_authorization_code do
    let(:authorization_code) { user.authorization_codes.create }

    subject { user.invalidate_authorization_code(authorization_code.code) }

    it 'will mark the authorization code as invalid' do
      expect { subject }.to change(authorization_code, :valid).to(false)
    end
  end

  describe :active_registered_devices do
    let(:user) { Fabricate(:user) }
    let!(:active_registered_device) { user.registered_devices.create(registration_id: '42') }
    let!(:inactive_registered_device) { user.registered_devices.create }

    subject { user.active_registered_devices }

    it { should == [active_registered_device] }
  end
end
