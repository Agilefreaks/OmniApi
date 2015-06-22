require 'spec_helper'

describe Client do
  it { should be_timestamped_document }
  it { should have_field(:url).of_type(String) }
  it { should have_field(:secret).of_type(String) }
  it { should embed_many(:access_tokens) }
  it { should embed_many(:scopes) }

  its(:secret) { should_not be_nil }

  describe 'save' do
    context 'when no access tokens where added' do
      it 'will add an access token before save' do
        client = Fabricate(:client)
        expect(client.access_tokens.count).to eq 1
      end
    end

    context 'when an access token was added' do
      it 'will not add a new one' do
        client = Fabricate.build(:client)
        client.access_tokens.push(AccessToken.build)

        client.save

        expect(client.reload.access_tokens.count).to eq 1
      end
    end

    context 'url is specified' do
      let(:url) { 'https://some42url.com/' }

      it 'saves the url' do
        client = Fabricate.build(:client)
        client.url = url

        client.save

        expect(client.reload.url).to eq(url)
      end
    end
  end

  describe :find_by_token do
    let(:client) { Fabricate(:client) }

    subject { Client.find_by_token(client.access_tokens.first.token) }

    it { should == client }
  end
end
