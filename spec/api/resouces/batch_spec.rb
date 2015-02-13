require 'spec_helper'

describe :batch do
  include_context :with_authenticated_user

  describe "POST '/api/v1/batch'" do
    let(:params) do
      {
        requests: [
          {
            method: 'POST',
            path: '/api/v1/user/contacts',
            body: { contact_id: '42', first_name: 'Tom', last_name: 'Diakite' }
          },
          {
            method: 'POST',
            path: '/api/v1/user/contacts',
            body: { contact_id: '43', first_name: 'Florence', last_name: 'the Machine', middle_name: 'the' }
          }
        ]
      }
    end

    subject { post '/api/v1/batch', params.to_json, options }

    it 'will create contacts' do
      expect { subject }.to change { user.contacts.count }.by(2)
    end
  end
end