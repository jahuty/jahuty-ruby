# frozen_string_literal: true

module Jahuty
  RSpec.describe Client do
    subject(:client) { described_class.new(api_key: 'foo') }

    let(:action) { Action::Show.new(resource: 'render', id: 1) }
    let(:url)    { 'https://api.jahuty.com/snippets/1/render' }

    describe '#method_missing' do
      context 'when the missing method is a set' do
        it 'raises error' do
          expect { client.foo = 1 }.to raise_error(NoMethodError)
        end
      end

      context 'when the missing method is a call' do
        it 'raises error' do
          expect { client.foo(1) }.to raise_error(NoMethodError)
        end
      end

      context 'when the missing method is an invalid get' do
        it 'raises error' do
          expect { client.foo }.to raise_error(NoMethodError)
        end
      end

      context 'when the missing method is a valid get' do
        it 'returns service' do
          expect(client.snippets).to be_instance_of(Service::Snippet)
        end
      end
    end

    describe '#respond_to?' do
      context 'when service name is not valid' do
        it 'returns false' do
          expect(client).not_to respond_to(:foo)
        end
      end

      context 'when the service name is valid' do
        it 'returns true' do
          expect(client).to respond_to(:snippets)
        end
      end
    end

    describe '#request' do
      context 'when the action succeeds' do
        before do
          stub_request(:get, url)
            .to_return(status: 200, body: '{"content":"foo"}', headers: {})
        end

        it 'returns render' do
          expect(client.request(action)).to be_instance_of(Resource::Render)
        end
      end

      context 'when the action fails' do
        before do
          stub_request(:get, url)
            .to_return(
              status: 404,
              body: '{ "status":404, "type": "foo", "detail": "bar" }',
              headers: {
                'Content-Type' => 'application/problem+json'
              }
            )
        end

        it 'raises error' do
          expect { client.request(action) }.to raise_error(Exception::Error)
        end
      end
    end

    describe '#fetch' do
      context 'when the action succeeds' do
        before do
          stub_request(:get, url)
            .to_return(status: 200, body: '{"content":"foo"}', headers: {})
        end

        it 'returns render' do
          expect(client.fetch(action)).to be_instance_of(Resource::Render)
        end
      end
    end
  end
end
