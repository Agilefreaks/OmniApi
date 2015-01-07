require 'spec_helper'

describe PhoneCall do
  it { is_expected.to belong_to(:user) }
end
