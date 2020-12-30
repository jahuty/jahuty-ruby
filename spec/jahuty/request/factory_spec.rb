# frozen_string_literal: true

module Jahuty
  module Request
    RSpec.describe Factory do
      describe '#call' do
        subject(:factory) { described_class.new }

        let(:action) { ::Jahuty::Action::Show.new(id: 1, resource: 'foo') }

        it 'returns request' do
          expect(factory.call(action)).to be_instance_of(Base)
        end
      end
    end
  end
end
