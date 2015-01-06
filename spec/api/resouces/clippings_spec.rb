require 'spec_helper'

describe API::Resources::Clippings do
  include_context :with_authenticated_user

  describe "POST 'api/v1/clippings'" do
    let(:params) { { content: 'content', identifier: 'identifier' } }

    it 'will call create with the correct params on the factory' do
      allow(CreateClipping).to receive(:with).and_return(Fabricate(:clipping))
      with_params = { access_token: access_token.token, content: 'content', identifier: 'identifier' }
      expect(CreateClipping).to receive(:with).with(with_params)

      post '/api/v1/clippings', params.to_json, options
    end
  end

  describe "GET 'api/v1/clippings/last'" do
    let(:clipping) { Fabricate(:clipping, content: 'content') }

    it 'calls FindClipping for with correct argument' do
      allow(FindClipping).to receive(:for).with(access_token.token).and_return(clipping)
      get '/api/v1/clippings/last', nil, options
      expect(last_response.body).to eql API::Entities::Clipping.new(clipping).to_json
    end
  end
end
