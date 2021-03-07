# frozen_string_literal: true

module Jahuty
  module Resource
    RSpec.describe Render do
      subject(:render) { described_class.new(content: content, snippet_id: snippet_id) }

      let(:snippet_id) { 1 }
      let(:content)    { 'foo' }

      describe '#initialize' do
        it 'sets content' do
          expect(render.content).to eq(content)
        end

        it 'sets snippet_id' do
          expect(render.snippet_id).to eq(snippet_id)
        end
      end

      describe '#to_s' do
        it 'returns content' do
          expect(render.to_s).to eq(content)
        end
      end

      describe 'serialization' do
        it 'does not raise error' do
          expect { Marshal.load(Marshal.dump(render)) }.not_to raise_error
        end

        it 'has correct attributes' do
          expect(Marshal.load(Marshal.dump(render))).to have_attributes(content: 'foo')
        end
      end

      describe '::from' do
        let(:data) { { content: 'foo', snippet_id: 1 } }

        it 'raises error if :content key does not exist' do
          data.delete(:content)

          expect { described_class.from(data) }.to raise_error(ArgumentError)
        end

        it 'raises error if :snippet_id key does not exist' do
          data.delete(:snippet_id)

          expect { described_class.from(data) }.to raise_error(ArgumentError)
        end

        it 'does not raise error if unused key exists' do
          data[:foo] = 'bar'

          expect { described_class.from(data) }.not_to raise_error
        end

        it 'returns render' do
          expect(described_class.from(data)).to be_instance_of(Render)
        end
      end
    end
  end
end
