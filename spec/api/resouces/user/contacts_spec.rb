require 'spec_helper'

describe API::Resources::User::Contacts do
  include_context :with_authenticated_user

  describe "POST 'api/v1/user/contacts'" do
    let(:params) do
      {
        contact_id: 'someId12',
        first_name: 'John',
        last_name: 'Doe',
        phone_numbers: %w(123 456),
        image: 'someData'
      }
    end

    before do
      post '/api/v1/user/contacts', params.to_json, options.merge('HTTP_CLIENT_VERSION' => '42')
    end

    subject { JSON.parse(last_response.body) }

    its(['contact_id']) { is_expected.to eq 'someId12' }

    its(['first_name']) { is_expected.to eq 'John' }

    its(['last_name']) { is_expected.to eq 'Doe' }

    its(['phone_numbers']) { is_expected.to eq %w(123 456) }

    its(['image']) { is_expected.to eq 'someData' }
  end
end
