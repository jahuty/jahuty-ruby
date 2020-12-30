# frozen_string_literal: true

module Jahuty
  module Request
    RSpec.describe Base do
      describe '#initialize' do
        let(:method) { 'get' }
        let(:path)   { 'foo/bar/baz' }
        let(:params) { { qux: 'quux' } }

        subject(:request) do
          Base.new(method: method, path: path, params: params)
        end

        it 'sets the method' do
          expect(request.method).to eq(method)
        end

        it 'sets the path' do
          expect(request.path).to eq(path)
        end

        it 'sets the params' do
          expect(request.params).to eq(params)
        end
      end
    end
  end
end
