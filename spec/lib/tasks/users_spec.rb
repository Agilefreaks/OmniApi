require 'spec_helper'

describe 'users' do
  before :all do
    load File.expand_path('../../../../lib/tasks/users.rake', __FILE__)
    Rake::Task.define_task(:environment)
  end

  describe 'users:active' do
    let(:user) { Fabricate(:user, email: 'train@user.com') }
    let(:interval) { 1.week.ago }

    subject do
      Rake::Task['users:active'].reenable
      Rake::Task['users:active'].invoke(interval)
    end

    context 'clippings' do
      before :each do
        user.clippings << clipping
      end

      context 'when user has a clipping in the time interval' do
        let(:clipping) { Fabricate(:clipping, created_at: interval + 1.minute) }

        it 'will return the users email' do
          expect(UsersOutput).to receive(:puts).with(%w(train@user.com))
          subject
        end
      end

      context 'when user has no clippings in the time interval' do
        let(:clipping) { Fabricate(:clipping, created_at: interval - 1.minute) }

        it 'will not print a email' do
          expect(UsersOutput).not_to receive(:puts)
          subject
        end
      end
    end

    context 'phone_calls' do
      before :each do
        user.phone_calls << phone_call
      end

      context 'when the user has an phone call in the time interval' do
        let(:phone_call) { Fabricate(:phone_call, created_at: interval + 1.minute, number: '123') }

        it 'will return the users email' do
          expect(UsersOutput).to receive(:puts).with(%w(train@user.com))
          subject
        end
      end

      context 'when user has no events in the time interval' do
        let(:created_at) { interval - 1.minute }
        let(:phone_call) { Fabricate(:phone_call, created_at: created_at, number: '123') }

        it 'will return the users email' do
          expect(UsersOutput).not_to receive(:puts)
          subject
        end
      end
    end

    context 'sms_messages' do
      before :each do
        user.sms_messages << sms_message
      end

      context 'when the user has an phone call in the time interval' do
        let(:sms_message) { Fabricate(:sms_message, created_at: interval + 1.minute, phone_number: '123') }

        it 'will return the users email' do
          expect(UsersOutput).to receive(:puts).with(%w(train@user.com))
          subject
        end
      end

      context 'when user has no events in the time interval' do
        let(:created_at) { interval - 1.minute }
        let(:sms_message) { Fabricate(:sms_message, created_at: created_at, phone_number: '123') }

        it 'will return the users email' do
          expect(UsersOutput).not_to receive(:puts)
          subject
        end
      end
    end
  end
end
