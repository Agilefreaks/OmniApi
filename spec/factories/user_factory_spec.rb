require 'spec_helper'

describe UserFactory do
  describe :create do
    let(:client) { Client.new }
    subject { UserFactory.new.create(client, email: 'some@email.com') }

    its(:new_record?) { should == false }

    its(:email) { should == 'some@email.com' }

    its('access_tokens.count') { should == 1 }
  end
end
