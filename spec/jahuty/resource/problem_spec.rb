module Jahuty
  module Resource
    RSpec.describe Problem do
      describe '#initialize' do
        let(:status) { 404 }
        let(:type)   { 'foo' }
        let(:detail) { 'bar' }

        subject(:problem) { Problem.new(status: status, type: type, detail: detail) }

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
    end
  end
end
