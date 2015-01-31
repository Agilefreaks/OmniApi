require 'spec_helper'

describe API::Resources::Clippings do
  include_context :with_authenticated_user

  describe "POST 'api/v1/clippings'" do
    let(:params) { { content: 'content' } }

    subject { post '/api/v1/clippings', params.to_json, options }

    before do
      params.merge!(device_id: 'Finally gotten over you')
    end

    it 'will call create with the correct params' do
      with_params = { access_token: access_token.token, content: 'content', device_id: 'Finally gotten over you' }
      expect(CreateClipping).to receive(:with).with(with_params)

      subject
    end
  end

  describe "GET 'api/v1/clippings/:id.json'" do
    let(:clipping) { Fabricate(:clipping, user: user, content: "Keep of braggin'") }

    before do
      get "/api/v1/clippings/#{clipping._id}.json", '', options
    end

    subject { JSON.parse(last_response.body) }

    its(['content']) { is_expected.to eq "Keep of braggin'" }
  end
end
