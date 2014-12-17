require 'spec_helper'

describe UserBuilder do
  describe :build do
    let(:client) { Client.new }
    subject { UserBuilder.new.build(client, email: 'some@email.com') }

    its(:new_record?) { should == false }

    its(:email) { should == 'some@email.com' }

    its('access_tokens.count') { should == 1 }
  end
end
