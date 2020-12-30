# frozen_string_literal: true

module Jahuty
  module Service
    RSpec.describe Factory do
      subject(:factory) do
        described_class.new(client: instance_double('::Jahuty::Client'))
      end

      describe '#call' do
        context 'when service name not found' do
          it 'raises error' do
            expect { factory.foo }.to raise_error(NoMethodError)
          end
        end

        context 'when service is not instantiated' do
          it 'returns instance' do
            expect(factory.snippets).to be_instance_of(Snippet)
          end
        end

        context 'when service is instantiated' do
          it 'returns memoized instance' do
            expect(factory.snippets).to eq(factory.snippets)
          end
        end
      end

      describe '#method_missing' do
        context 'when the missing method is a set' do
          it 'raises error' do
            expect { factory.foo = 1 }.to raise_error(NoMethodError)
          end
        end

        context 'when the missing method is a call' do
          it 'raises error' do
            expect { factory.foo(1) }.to raise_error(NoMethodError)
          end
        end

        context 'when the missing method is an invalid get' do
          it 'raises error' do
            expect { factory.foo }.to raise_error(NoMethodError)
          end
        end

        context 'when the missing method is a valid get' do
          it 'returns service' do
            expect(factory.snippets).to be_instance_of(Snippet)
          end
        end
      end

      describe '#respond_to?' do
        context 'when the service name is not valid' do
          it 'returns false' do
            expect(factory).not_to respond_to(:foo)
          end
        end

        context 'when the service name is valid' do
          it 'returns true' do
            expect(factory).to respond_to(:snippets)
          end
        end
      end
    end
  end
end
