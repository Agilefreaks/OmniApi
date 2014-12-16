require 'spec_helper'

describe AuthorizationCode do
  it { should have_field(:code) }
  it { should have_field(:expires_at) }
  it { should have_field(:active) }

  it { should be_embedded_in(:user) }

  it { should validate_presence_of(:code) }

  describe :default_scope do
    let(:user) { Fabricate(:user) }

    subject { user.authorization_codes }

    context 'with valid code' do
      before do
        user.authorization_codes.create!(active: true)
      end

      its(:count) { should == 1 }
    end

    context 'with invalid code' do
      before do
        user.authorization_codes.create!(active: false)
      end

      its(:count) { should == 0 }
    end

    context 'with expired code' do
      before do
        user.authorization_codes.create!(active: true, expires_at: Time.now - 1.hour)
      end

      its(:count) { should == 0 }
    end

    context 'with unexpired code' do
      before do
        user.authorization_codes.create!(active: true, expires_at: Time.now + 1.second)
      end

      its(:count) { should == 1 }
    end
  end
end
