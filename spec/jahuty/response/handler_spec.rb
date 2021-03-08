# frozen_string_literal: true

module Jahuty
  module Response
    RSpec.describe Handler do
      subject(:handler) { described_class.new }

      let(:show)  { Action::Show.new(id: 1, resource: 'render') }
      let(:index) { Action::Index.new(resource: 'render') }

      describe '#call' do
        # An unexpected response has either (a) a 2xx status code without the
        # 'application/json' content-type; or (b) another status code without
        # the 'application/problem+json' content type.
        context 'when response is unexpected' do
          # Expects 'application/json'.
          let(:response) { stub_response(content_type: 'foo') }

          it 'raises error' do
            expect { handler.call show, response }.to raise_error(ArgumentError)
          end
        end

        context 'when response is invalid json' do
          let(:response) { stub_response(body: 'foo') }

          it 'raises error' do
            expect { handler.call show, response }.to raise_error(JSON::ParserError)
          end
        end

        context 'when action and response mismatch' do
          # Expects an array.
          let(:response) { stub_response(body: '{"content":"foo"}') }

          it 'raises error' do
            expect { handler.call index, response }.to raise_error(ArgumentError)
          end
        end

        context 'when response is a problem' do
          let(:response) do
            stub_response(
              status: 404,
              content_type: 'application/problem+json',
              body: '{"status": 200, "type": "foo", "detail": "bar" }'
            )
          end

          it 'returns problem' do
            expect(handler.call(show, response)).to be_instance_of(Resource::Problem)
          end
        end

        context 'when collection' do
          let(:response) do
            stub_response(
              body: '[{"snippet_id":1,"content":"foo"},{"snippet_id":2,"content":"bar"}]'
            )
          end

          it 'returns array' do
            expect(handler.call(index, response)).to be_instance_of(Array)
          end
        end

        context 'when resource' do
          let(:response) { stub_response(body: '{"snippet_id":1,"content":"foo"}') }

          it 'returns render' do
            expect(handler.call(show, response)).to be_instance_of(Resource::Render)
          end
        end
      end

      private

      def stub_response(status: 200, body: '', content_type: 'application/json')
        headers = instance_double('::Faraday::Headers')

        allow(headers).to receive(:[])
          .with('Content-Type')
          .and_return(content_type)

        response = instance_double('::Faraday::Response')

        allow(response).to receive_messages(status: status, body: body, headers: headers)

        response
      end
    end
  end
end
