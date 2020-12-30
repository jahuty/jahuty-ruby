module Jahuty
  module Service
    RSpec.describe Snippet do
      describe '#render' do
        it 'requests action' do
          client = instance_double('::Jahuty::Client')

          expect(client).to receive(:request).with(
            having_attributes(id: 1, resource: 'render')
          )

          service = Snippet.new(client: client)

          service.render(1)
        end

        context 'when params do not exist' do
          it 'does not include params' do
            client = instance_double('::Jahuty::Client')

            expect(client).to receive(:request).with(
              having_attributes(params: {})
            )

            service = Snippet.new(client: client)

            service.render(1)
          end
        end

        context 'when params do not exist' do
          it 'does include params' do
            client = instance_double('::Jahuty::Client')

            expect(client).to receive(:request).with(
              having_attributes(params: { params: '{"foo":"bar"}' })
            )

            service = Snippet.new(client: client)

            service.render(1, { params: { foo: 'bar' } })
          end
        end
      end
    end
  end
end
