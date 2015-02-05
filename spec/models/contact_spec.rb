require 'spec_helper'

describe Contact do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:contact_id) }
end
