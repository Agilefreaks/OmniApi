require 'spec_helper'

describe SmsMessage do
  it { is_expected.to validate_inclusion_of(:state).to_allow(%w(sending sent received)) }
end
