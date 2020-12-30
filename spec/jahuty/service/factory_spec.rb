module Jahuty
  module Service
    RSpec.describe Factory do
      describe '#call' do
        subject(:factory) do
          Factory.new(client: instance_double('::Jahuty::Client'))
        end

        context 'when service name not found' do
          it 'raises error' do
            expect {
              factory.foo
            }.to raise_error(ArgumentError)
          end
        end

        context 'when service is not instantiated' do
          it 'returns instance' do
            expect(factory.snippets).to be_instance_of(Snippet)
          end
        end

        context 'when service is instantiated' do
          it 'returns memoized instance' do
            expect(factory.snippets).to eq(factory.snippets)
          end
        end
      end
    end
  end
end
