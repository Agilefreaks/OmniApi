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

    context 'events' do
      before :each do
        user.events << event
      end

      context 'when the user has a event in the time interval' do
        let(:event) { Fabricate(:incoming_call_event, created_at: interval + 1.minute) }

        it 'will return the users email' do
          expect(UsersOutput).to receive(:puts).with(%w(train@user.com))
          subject
        end
      end

      context 'when user has no events in the time interval' do
        let(:event) { Fabricate(:incoming_sms_event, created_at: interval - 1.minute) }

        it 'will return the users email' do
          expect(UsersOutput).not_to receive(:puts)
          subject
        end
      end
    end
  end
end
