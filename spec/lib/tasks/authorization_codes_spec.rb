require 'spec_helper'

describe 'authorization_codes' do
  before do
    load File.expand_path('../../../../lib/tasks/authorization_codes.rake', __FILE__)
    Rake::Task.define_task(:environment)
  end

  describe 'remove_expired' do
    it 'will remove expired tokens' do
      user = Fabricate(:user)
      user.authorization_codes.push(AuthorizationCode.new(code: '123', active: false))
      user.authorization_codes.push(AuthorizationCode.new(code: '1234', active: true))
      user.save

      Rake::Task['authorization_codes:remove_expired'].invoke

      user.reload
      expect(user.authorization_codes.unscoped.count).to eq 1
    end
  end

  describe 'expired_active_count' do
    it 'will return the count of tokens expired but still active (not used)' do
      user = Fabricate(:user)
      user.authorization_codes.push(AuthorizationCode.new(code: '12', active: false))
      user.authorization_codes.push(AuthorizationCode.new(code: '123', active: true, expires_at: Time.now - 1.day))
      user.authorization_codes.push(AuthorizationCode.new(code: '1234', active: true, expires_at: Time.now - 2.days))

      puts Rake::Task['authorization_codes:remove_expired'].invoke
    end
  end
end
