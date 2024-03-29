require 'spec_helper'

describe ClippingBuilder do
  let(:builder) { ClippingBuilder.new }

  describe :build do
    include_context :with_authenticated_user

    subject { builder.build(access_token.token, content) }

    context 'when content is string' do
      let(:content) { 'some' }

      its(:new_record?) { should == false }

      its(:user) { should == user }

      its(:type) { should == :unknown }

      its(:content) { should == 'some' }
    end

    context 'when content is phone' do
      let(:content) { '+40745857479' }

      its(:type) { should == :phone_number }
    end

    context 'when content contains numbers' do
      let(:content) { 'some 1234' }

      its(:type) { should == :unknown }
    end

    context 'when content is phone without prefix' do
      let(:content) { '0745857479' }

      its(:type) { should == :phone_number }
    end

    context 'when content is https link' do
      let(:content) { 'https://news.ycombinator.com/item?id=6602902' }

      its(:content) { should == 'https://news.ycombinator.com/item?id=6602902' }

      its(:type) { should == :url }
    end

    context 'when content contains http link' do
      let(:content) { 'asdasdasd http://google.com' }

      its(:type) { should == :unknown }
    end

    context 'when content is address' do
      let(:content) { 'str. Avram Iancu, nr. 1 - 3, ap. 5' }

      its(:type) { should == :address }
    end

    context 'when content content contains polish letters' do
      let(:content) { 'Dajwór 25, 31-052 Kraków, Poland' }

      its(:type) { should == :address }
    end
  end
end
