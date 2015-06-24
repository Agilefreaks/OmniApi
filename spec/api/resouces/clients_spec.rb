require 'spec_helper'

describe API::Resources::Clients do
  include_context :with_authenticated_client

  describe "GET 'api/v1/clients/:id'" do
    let(:scope) { Scope.create(key: :phone_calls_create, description: 'Some description') }
    let(:client) { Client.create!(name: 'test', scopes: [scope]) }
    let(:action) { get "/api/v1/clients/#{client.id}", '', options }

    subject { action }

    its(:status) { is_expected.to eq(200) }

    describe 'response body' do
      subject { JSON.parse(action.body) }

      its(['name']) { is_expected.to eq('test') }

      its(['scopes']) do
        is_expected.to eq([{ 'id' => scope.id.to_s,
                             'key' => 'phone_calls_create',
                             'description' => 'Some description' }])
      end
    end
  end
end
