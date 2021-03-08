# frozen_string_literal: true

module Jahuty
  module Resource
    RSpec.describe Factory do
      describe '#call' do
        subject(:factory) { described_class.new }

        context 'with an invalid resource' do
          it 'raises error' do
            expect { factory.call 'foo', {} }.to raise_error(ArgumentError)
          end
        end

        context 'with a valid resource' do
          it 'returns render' do
            expect(factory.call('render', { content: 'foo', snippet_id: 1 })).to be_instance_of(Render)
          end
        end
      end
    end
  end
end
