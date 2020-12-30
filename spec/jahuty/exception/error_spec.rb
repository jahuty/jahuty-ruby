# frozen_string_literal: true

module Jahuty
  module Exception
    RSpec.describe Error do
      describe '#message' do
        let(:status)  { 1 }
        let(:type)    { 'foo' }
        let(:detail)  { 'bar' }

        let(:problem) do
          ::Jahuty::Resource::Problem.new(
            status: status,
            type:   type,
            detail: detail
          )
        end

        subject(:exception) { Error.new(problem) }

        it 'returns message' do
          expect(exception.message).to include(status.to_s, type, detail)
        end
      end
    end
  end
end
