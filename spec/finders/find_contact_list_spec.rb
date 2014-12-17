require 'spec_helper'

describe FindContactList do
  describe :for do
    let(:user) { Fabricate(:user) }
    let(:access_token) { AccessToken.build }

    before do
      user.access_tokens.push(access_token)
      user.save

      Fabricate(:contact_list, device_identifier: 'Guitar', contacts: 'Led Zeppelin', user: user)
    end

    subject { FindContactList.for(access_token: access_token.token, device_identifier: 'Guitar') }

    its(:contacts) { is_expected.to eq 'Led Zeppelin' }
  end
end
