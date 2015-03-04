require 'spec_helper'

describe PhoneCall do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_inclusion_of(:state).to_allow(%w(starting started ended ending)) }
end
