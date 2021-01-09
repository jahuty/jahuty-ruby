# frozen_string_literal: true

# context 'when the cache is not supported' do
#   # Any object which doesn't respond to get/set or read/write will do.
#   let(:cache)  { Object.new }
#   let(:client) { instance_double(Jahuty::Client) }
#
#   it 'raises error' do
#     expect { manager.fetch action }.to raise_error(NoMethodError)
#   end
# end

module Jahuty
  module Cache
    # A concrete cache implementation for doubles.
    class Cache
      def read(key); end

      def write(key, value, options = nil); end

      def delete(key); end
    end

    RSpec.describe Facade do
      subject(:facade) { described_class.new(cache) }

      describe '#delete' do
        context 'when the implementation is not supported' do
          let(:cache) { Object.new }

          it 'raises error' do
            expect { facade.delete 'foo' }.to raise_error(NoMethodError)
          end
        end

        context 'when the implementation is supported' do
          let(:cache) do
            cache = instance_double(Cache)
            allow(cache).to receive(:delete)

            cache
          end

          before { facade.delete 'foo' }

          it 'calls delete' do
            expect(cache).to have_received(:delete).with('foo')
          end
        end
      end

      describe '#read' do
        context 'when the implementation is not supported' do
          let(:cache) { Object.new }

          it 'raises error' do
            expect { facade.read 'foo' }.to raise_error(NoMethodError)
          end
        end

        context 'when the implementation is supported' do
          let(:cache) do
            cache = instance_double(Cache)
            allow(cache).to receive(:read)

            cache
          end

          before { facade.read 'foo' }

          it 'calls delete' do
            expect(cache).to have_received(:read).with('foo')
          end
        end
      end

      describe '#write' do
        context 'when the implementation is not supported' do
          let(:cache) { Object.new }

          it 'raises error' do
            expect { facade.write 'foo', 'bar' }.to raise_error(NoMethodError)
          end
        end

        context 'when the implementation is supported' do
          let(:cache) do
            cache = instance_double(Cache)
            allow(cache).to receive(:write)

            cache
          end

          before { facade.write 'foo', 'bar' }

          it 'calls delete' do
            expect(cache).to have_received(:write).with('foo', 'bar', expires_in: nil)
          end
        end
      end
    end
  end
end
