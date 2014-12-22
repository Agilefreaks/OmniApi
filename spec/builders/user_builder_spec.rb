require 'spec_helper'

describe UserBuilder do
  describe :build do
    let(:client) { Client.new }
    subject { UserBuilder.new.build(client, email: 'some@email.com') }

    its(:new_record?) { should == false }

    its(:email) { should == 'some@email.com' }

    its('access_tokens.count') { should == 1 }

    it 'will set via_omnipaste 50%' do
      via_omnipaste = 0
      100.times do |i|
        user = UserBuilder.new.build(client, email: "some#{i}@email.com")
        via_omnipaste += 1 if user.via_omnipaste
      end
      expect(via_omnipaste).to be <= 60
    end
  end
end
