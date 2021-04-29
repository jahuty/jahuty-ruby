# frozen_string_literal: true

module Jahuty
  module Service
    RSpec.describe Snippet do
      subject(:snippets) do
        described_class.new(client: client, cache: cache)
      end

      let(:render) { Jahuty::Resource::Render.new(content: 'foo', snippet_id: 1) }

      let(:client) do
        client = instance_double('::Jahuty::Client')

        allow(client).to receive(:request)

        client
      end

      let(:cache) do
        cache = instance_double('::Jahuty::Cache::Facade')

        allow(cache).to receive(:read)
        allow(cache).to receive(:write)
        allow(cache).to receive(:delete)

        cache
      end

      describe '#all_renders' do
        context 'when expires_in is positive' do
          let(:expires_in) { 30 }

          before do
            allow(client).to receive(:request).and_return([render])

            snippets.all_renders 'foo', expires_in: expires_in
          end

          it 'takes precedence' do
            expect(cache).to have_received(:write).with(
              anything, anything, hash_including(expires_in: expires_in)
            )
          end
        end

        context 'when expires_in is zero' do
          before do
            allow(client).to receive(:request).and_return([])

            snippets.all_renders 'foo', expires_in: 0
          end

          it 'does not cache value' do
            expect(cache).not_to have_received(:write)
          end
        end

        context 'when params do not exist' do
          let(:expected_attr) { { resource: 'render', params: { tag: 'foo' } } }

          before { allow(client).to receive(:request).and_return([]) }

          it 'does not include params' do
            snippets.all_renders 'foo'

            expect(client).to have_received(:request)
              .with(having_attributes(expected_attr))
          end
        end

        context 'when params do exist' do
          let(:expected_attr) do
            { resource: 'render', params: { tag: 'foo', params: '{"*":{"foo":"bar"}}' } }
          end

          before { allow(client).to receive(:request).and_return([]) }

          it 'does include params' do
            snippets.all_renders 'foo', params: { '*' => { foo: 'bar' } }

            expect(client).to have_received(:request)
              .with(having_attributes(expected_attr))
          end
        end

        context 'with prefer_latest option' do
          let(:expected_attr) do
            { resource: 'render', params: { tag: 'foo', latest: 1 } }
          end

          before { allow(client).to receive(:request).and_return([]) }

          it 'has latest' do
            snippets.all_renders 'foo', prefer_latest: true

            expect(client).to have_received(:request)
              .with(having_attributes(expected_attr))
          end
        end

        context 'when a collection is returned' do
          before { allow(client).to receive(:request).and_return([render]) }

          it 'returns the cached value' do
            expect(snippets.all_renders('foo')).to eq([render])
          end

          it 'sends API request' do
            snippets.all_renders 'foo'

            expect(client).to have_received(:request)
          end

          it 'caches value' do
            snippets.all_renders 'foo'

            expect(cache).to have_received(:write).with(anything, render, anything)
          end
        end
      end

      describe '#render' do
        context 'when the render is cached' do
          before { allow(cache).to receive(:read).and_return(render) }

          it 'returns the cached value' do
            expect(snippets.render(1)).to eq(render)
          end

          it 'does not send API request' do
            snippets.render 1

            expect(client).not_to have_received(:request)
          end

          it 'does not cache value' do
            snippets.render 1

            expect(cache).not_to have_received(:write)
          end
        end

        context 'when the render is not cached' do
          before { allow(client).to receive(:request).and_return(render) }

          it 'returns the cached value' do
            expect(snippets.render(1)).to eq(render)
          end

          it 'sends API request' do
            snippets.render 1

            expect(client).to have_received(:request)
          end

          it 'caches value' do
            snippets.render 1

            expect(cache).to have_received(:write)
          end
        end

        context 'when expires_in is positive' do
          let(:expires_in) { 30 }

          before do
            allow(client).to receive(:request).and_return(render)

            snippets.render 1, expires_in: expires_in
          end

          it 'takes precedence' do
            expect(cache).to have_received(:write).with(
              anything, anything, hash_including(expires_in: expires_in)
            )
          end
        end

        context 'when expires_in is zero' do
          before do
            allow(cache).to receive(:read).and_return(render)

            snippets.render 1, expires_in: 0
          end

          it 'deletes render from cache' do
            expect(cache).to have_received(:delete)
          end

          it 'does not cache value' do
            expect(cache).not_to have_received(:write)
          end
        end

        context 'when params do not exist' do
          let(:expected_attr) { { id: 1, resource: 'render', params: {} } }

          it 'does not include params' do
            snippets.render 1

            expect(client).to have_received(:request)
              .with(having_attributes(expected_attr))
          end
        end

        context 'when params do exist' do
          let(:expected_attr) do
            { id: 1, resource: 'render', params: { params: '{"foo":"bar"}' } }
          end

          it 'does include params' do
            snippets.render 1, params: { foo: 'bar' }

            expect(client).to have_received(:request)
              .with(having_attributes(expected_attr))
          end
        end

        context 'with prefer_latest option' do
          let(:expected_attr) do
            { id: 1, resource: 'render', params: { latest: 1 } }
          end

          it 'has latest' do
            snippets.render 1, prefer_latest: true

            expect(client).to have_received(:request)
              .with(having_attributes(expected_attr))
          end
        end
      end
    end
  end
end
