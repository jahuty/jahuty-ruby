# frozen_string_literal: true

module Jahuty
  module Resource
    RSpec.describe Problem do
      describe '#initialize' do
        subject(:problem) do
          described_class.new(status: status, type: type, detail: detail)
        end

        let(:status) { 404 }
        let(:type)   { 'foo' }
        let(:detail) { 'bar' }

        it 'sets status' do
          expect(problem.status).to eq(status)
        end

        it 'sets type' do
          expect(problem.type).to eq(type)
        end

        it 'sets detail' do
          expect(problem.detail).to eq(detail)
        end
      end

      describe '::from' do
        let(:data) { { status: 1, type: 'foo', detail: 'bar' } }

        it 'raises error if :status key does not exist' do
          data.delete(:status)

          expect { described_class.from(data) }.to raise_error(ArgumentError)
        end

        it 'raises error if :type key does not exist' do
          data.delete(:type)

          expect { described_class.from(data) }.to raise_error(ArgumentError)
        end

        it 'raises error if :detail key does not exist' do
          data.delete(:detail)

          expect { described_class.from(data) }.to raise_error(ArgumentError)
        end

        it 'does not raise error if unused key exists' do
          data[:foo] = 'bar'

          expect { described_class.from(data) }.not_to raise_error
        end
      end
    end
  end
end
