# frozen_string_literal: true

module Jahuty
  module Cache
    # A concrete cache implementation for doubles.
    class Cache
      def read(key); end

      def write(key, value, options = nil); end

      def delete(key); end
    end

    RSpec.describe Manager do
      describe '#fetch' do
        subject(:manager) { described_class.new(cache: cache, client: client) }

        let(:render) { Jahuty::Resource::Render.new(content: 'foo') }
        let(:action) { Jahuty::Action::Show.new(resource: 'render', id: 1) }

        context 'when the action is not supported' do
          let(:invalid_action) { instance_double(Jahuty::Action::Base) }
          let(:cache)          { instance_double(Cache) }
          let(:client)         { instance_double(Jahuty::Client) }

          it 'raises error' do
            expect { manager.fetch invalid_action }.to raise_error(ArgumentError)
          end
        end

        context 'when the action is cached' do
          let(:cache) do
            cache = instance_double(Cache)
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

        context 'when the action is not cached' do
          let(:cache) do
            cache = instance_double(Cache)
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

        context 'when a non-zero :expires_in argument is passed' do
          let(:expires_in) { 30 }

          let(:cache) do
            cache = instance_double(Cache)
            allow(cache).to receive(:read).and_return(nil)
            allow(cache).to receive(:write)

            cache
          end

          let(:client) do
            client = instance_double(Jahuty::Client)
            allow(client).to receive(:request).and_return(render)

            client
          end

          before { manager.fetch action, expires_in: expires_in }

          it 'takes precedence' do
            expect(cache).to have_received(:write).with(
              anything, anything, hash_including(expires_in: expires_in)
            )
          end
        end

        context 'when a zero :expires_in argument is passed' do
          let(:cache) do
            cache = instance_double(Cache)
            allow(cache).to receive(:read).and_return(render)
            allow(cache).to receive(:write)
            allow(cache).to receive(:delete)

            cache
          end

          let(:client) do
            client = instance_double(Jahuty::Client)
            allow(client).to receive(:request).and_return(render)

            client
          end

          before { manager.fetch action, expires_in: 0 }

          it 'deletes value from cache' do
            expect(cache).to have_received(:delete)
          end

          it 'does not cache value' do
            expect(cache).not_to have_received(:write)
          end
        end
      end
    end
  end
end
