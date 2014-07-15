require 'spec_helper'

describe FindEvent do
  describe :for do
    include_context :with_authentificated_user

    let!(:event1) { user.events.create(identifier: 'Phone') }
    let!(:event2) { user.events.create(identifier: 'TV') }

    subject { FindEvent.for(access_token.token) }

    it { should == event2 }
  end
end
