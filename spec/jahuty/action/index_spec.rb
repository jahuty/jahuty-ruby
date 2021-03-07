# frozen_string_literal: true

module Jahuty
  module Action
    RSpec.describe Index do
      describe '#initialize' do
        subject(:index) do
          described_class.new(resource: resource, params: params)
        end

        let(:resource) { 'foo' }
        let(:params)   { { bar: 'baz' } }

        it 'sets resource' do
          expect(index.resource).to eq(resource)
        end

        it 'sets params' do
          expect(index.params).to eq(params)
        end
      end
    end
  end
end
