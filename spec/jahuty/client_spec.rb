# frozen_string_literal: true

module Jahuty
  RSpec.describe Client do
    subject(:client) { described_class.new(api_key: 'foo') }

    let(:action) { Action::Show.new(resource: 'render', id: 1) }
    let(:url)    { 'https://api.jahuty.com/snippets/1/render' }

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
  end
end
