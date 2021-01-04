# frozen_string_literal: true

module Jahuty
  module Cache
    # A cache implementation for doubles.
    class CacheImplementation
      def read(key); end

      def write(key, value, options = nil); end
    end

    RSpec.describe Manager do
      describe '#fetch' do
        subject(:manager) { described_class.new(cache: cache, client: client) }

        let(:render) { Jahuty::Resource::Render.new(content: 'foo') }
        let(:action) { Jahuty::Action::Show.new(resource: 'render', id: 1) }

        context 'with a cache hit' do
          let(:cache) do
            cache = instance_double(CacheImplementation)
            allow(cache).to receive(:read).and_return(render)
            allow(cache).to receive(:write)

            cache
          end

          let(:client) do
            client = instance_double(Jahuty::Client)
            allow(client).to receive(:request)

            client
          end

          it 'returns the cached value' do
            expect(manager.fetch(action)).to eq(render)
          end

          it 'does not send API request' do
            manager.fetch action

            expect(client).not_to have_received(:request)
          end

          it 'does not cache value' do
            manager.fetch action

            expect(cache).not_to have_received(:write)
          end
        end

        context 'with a cache miss' do
          let(:cache) do
            cache = instance_double(CacheImplementation)
            allow(cache).to receive(:read).and_return(nil)
            allow(cache).to receive(:write)

            cache
          end

          let(:client) do
            client = instance_double(Jahuty::Client)
            allow(client).to receive(:request).and_return(render)

            client
          end

          it 'sends API request' do
            manager.fetch action

            expect(client).to have_received(:request)
          end

          it 'caches the value' do
            manager.fetch action

            expect(cache).to have_received(:write)
          end

          it 'returns the value' do
            expect(manager.fetch(action)).to be_instance_of(Jahuty::Resource::Render)
          end
        end
      end
    end
  end
end
