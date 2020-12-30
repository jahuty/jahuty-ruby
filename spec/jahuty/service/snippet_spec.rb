# frozen_string_literal: true

module Jahuty
  module Service
    RSpec.describe Snippet do
      describe '#render' do
        subject(:snippet) do
          described_class.new(client: client)
        end

        let(:client) do
          client = instance_double('::Jahuty::Client')

          allow(client).to receive(:request)

          client
        end

        context 'when params do not exist' do
          let(:expected_attr) { { id: 1, resource: 'render', params: {} } }

          it 'does not include params' do
            snippet.render(1)

            expect(client).to have_received(:request)
              .with(having_attributes(expected_attr))
          end
        end

        context 'when params do exist' do
          let(:expected_attr) do
            { id: 1, resource: 'render', params: { params: '{"foo":"bar"}' } }
          end

          it 'does include params' do
            snippet.render(1, { params: { foo: 'bar' } })

            expect(client).to have_received(:request)
              .with(having_attributes(expected_attr))
          end
        end
      end
    end
  end
end
