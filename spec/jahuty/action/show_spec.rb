module Jahuty
  module Action
    RSpec.describe Show do
      describe '#initialize' do
        let(:id)       { 1 }
        let(:resource) { 'foo' }
        let(:params)   { { bar: 'baz' } }

        subject(:show) { Show.new(id: id, resource: resource, params: params) }

        it 'sets id' do
          expect(show.id).to eq(id)
        end

        it 'sets resource' do
          expect(show.resource).to eq(resource)
        end

        it 'sets params' do
          expect(show.params).to eq(params)
        end
      end
    end
  end
end
