require 'spec_helper'

describe API::Resources::Clippings do
  include_context :with_authenticated_user

  describe "POST 'api/v1/clippings'" do
    let(:params) { { content: 'content' } }

    subject { post '/api/v1/clippings', params.to_json, options }

    context 'with identifier' do
      before do
        params.merge!(identifier: 'identifier')
      end

      it 'will call create with the correct params' do
        with_params = { access_token: access_token.token, content: 'content', identifier: 'identifier' }
        expect(CreateClipping).to receive(:with).with(with_params)

        subject
      end
    end

    context 'with device_id' do
      before do
        params.merge!(device_id: 'Finally gotten over you')
      end

      it 'will call create with the correct params' do
        with_params = { access_token: access_token.token, content: 'content', device_id: 'Finally gotten over you' }
        expect(CreateClipping).to receive(:with).with(with_params)

        subject
      end
    end

    context 'with no device_id and no identifier' do
      it 'will fail' do
        subject
        expect(last_response).not_to be_created
      end
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

  describe "GET 'api/v1/clippings/:id.json'" do
    let(:clipping) { Fabricate(:clipping, user: user, content: "Keep of braggin'") }

    before do
      get "/api/v1/clippings/#{clipping._id}.json", '', options
    end

    subject { JSON.parse(last_response.body) }

    its(['content']) { is_expected.to eq "Keep of braggin'" }
  end
end
