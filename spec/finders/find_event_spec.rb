require 'spec_helper'

describe FindEvent do
  describe :for do
    include_context :with_authenticated_user

    before do
      user.events.create(identifier: 'Phone')
      user.events.create(identifier: 'TV')
    end

    subject { FindEvent.for(access_token.token) }

    its(:identifier) { should == 'TV' }
  end
end
