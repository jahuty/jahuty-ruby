# frozen_string_literal: true

module Jahuty
  RSpec.describe Util do
    # See https://github.com/rails/rails/blob/b881a646da09e1646edc3de0abe6a3ef36b06a99/activesupport/test/core_ext/hash_ext_test.rb
    describe '::deep_merge' do
      let(:hash1) { { a: 'a', b: 'b', c: { c1: 'c1', c2: 'c2', c3: { d1: 'd1' } } } }
      let(:hash2) { { a: 1, c: { c1: 2, c3: { d2: 'd2' } } } }

      it 'merges two hashes' do
        expect(described_class.deep_merge(hash1, hash2)).to eq(
          { a: 1, b: 'b', c: { c1: 2, c2: 'c2', c3: { d1: 'd1', d2: 'd2' } } }
        )
      end
    end
  end
end
