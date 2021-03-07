# frozen_string_literal: true

module Jahuty
  module Response
    RSpec.describe Handler do
      subject(:handler) { described_class.new }

      describe '#call' do


        let(:show)  { Action::Show.new(id: 1, resource: 'render') }
        let(:index) { Action::Index.new(resource: 'render') }

        # Setup the headers and response to use memoized values.
        let(:headers) do
          headers = instance_double('::Faraday::Headers')

          allow(headers).to receive(:[])
            .with('Content-Type')
            .and_return(content_type)

          headers
        end

        let(:response) do
          response = instance_double('::Faraday::Response')

          allow(response).to receive(:status).and_return(status)
          allow(response).to receive(:body).and_return(body)
          allow(response).to receive(:headers).and_return(headers)

          response
        end

        context 'when response is unexpected' do
          # An unexpected response has either (a) a 2xx status code without the
          # 'application/json' content-type; or (b) another status code without
          # the 'application/problem+json' content type.
          let(:status)       { 200 }
          let(:content_type) { 'foo' }  # Expects 'application/json'.
          let(:body)         { '[]' }

          it 'raises error' do
            expect { handler.call show, response }.to raise_error(ArgumentError)
          end
        end

        context 'when response is invalid json' do
          let(:status)       { 200 }
          let(:content_type) { 'application/json' }
          let(:body)         { 'foo' }

          it 'raises error' do
            expect { handler.call show, response }.to raise_error(JSON::ParserError)
          end
        end

        context 'when action and response mismatch' do
          let(:status)       { 200 }
          let(:content_type) { 'application/json' }
          let(:body)         { '{"content":"foo"}' }  # Expects an array.

          it 'raises error' do
            expect { handler.call index, response }.to raise_error(ArgumentError)
          end
        end

        context 'when response is a problem' do
          let(:status)       { 404 }
          let(:content_type) { 'application/problem+json' }
          let(:body)         { '{"status": 200, "type": "foo", "detail": "bar" }' }

          it 'returns problem' do
            expect(handler.call show, response).to be_instance_of(Resource::Problem)
          end
        end

        context 'when collection' do
          let(:status)       { 200 }
          let(:content_type) { 'application/json' }
          let(:body)         { '[{"snippet_id":1,"content":"foo"},{"snippet_id":2,"content":"bar"}]' }

          it 'returns array' do
            expect(handler.call index, response).to be_instance_of(Array)
          end
        end

        context 'when resource' do
          let(:status)       { 200 }
          let(:content_type) { 'application/json' }
          let(:body)         { '{"snippet_id":1,"content":"foo"}' }

          it 'returns render' do
            expect(handler.call show, response).to be_instance_of(Resource::Render)
          end
        end
      end
    end
  end
end
