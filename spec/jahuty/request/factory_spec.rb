# frozen_string_literal: true

module Jahuty
  module Request
    RSpec.describe Factory do
      subject(:factory) { described_class.new }

      let(:show)  { ::Jahuty::Action::Show.new(id: 1, resource: 'foo') }
      let(:index) { ::Jahuty::Action::Index.new(resource: 'foo') }

      describe '#call' do
        context 'when action is not supported' do
          it 'raises error' do
            expect { factory.call(Object.new) }.to raise_error(ArgumentError)
          end
        end

        context 'when action is show' do
          it 'returns request' do
            expect(factory.call(show)).to be_instance_of(Base)
          end
        end

        context 'when action is index' do
          it 'returns request' do
            expect(factory.call(index)).to be_instance_of(Base)
          end
        end
      end
    end
  end
end
