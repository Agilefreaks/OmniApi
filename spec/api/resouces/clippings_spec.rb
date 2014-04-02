require 'spec_helper'

describe API::Resources::Clippings do
  include Rack::Test::Methods

  def app
    OmniApi::App.instance
  end

  # rubocop:disable Blocks
  let(:options) {
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => "bearer #{access_token.token}"
    }
  }

  describe "POST 'api/v1/clippings'" do
    include_context :with_authentificated_user

    let(:params) { { content: 'content', identifier: 'identifier' } }

    it 'will call create with the correct params on the factory' do
      allow(CreateClipping).to receive(:with).and_return(Clipping.new)
      expect(CreateClipping).to receive(:with)
                                .with(access_token: access_token.token, content: 'content', identifier: 'identifier')

      post '/api/v1/clippings', params.to_json, options
    end
  end

  describe "GET 'api/v1/clippings/last'" do
    include_context :with_authentificated_user

    let(:clipping) { Clipping.new(content: 'content') }

    it 'calls FindClipping for with correct argument' do
      allow(FindClipping).to receive(:for).with(access_token.token).and_return(clipping)
      get '/api/v1/clippings/last', nil, options
      expect(last_response.body).to eql API::Entities::ClippingEntity.new(clipping).to_json
    end
  end
end
