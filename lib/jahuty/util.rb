# frozen_string_literal: true

module Jahuty
  # Utility methods.
  class Util
    # Deeply merges two hashes like Rails.
    #
    # Ideally, the API and this library could use the same method to merge
    # parameters. This library's method just needs to be deterministic and not
    # collide distinct combinations.
    #
    # @see  https://github.com/rails/rails/blob/main/activesupport/lib/active_support/core_ext/hash/deep_merge.rb
    def self.deep_merge(first_hash, other_hash, &block)
      first_hash.merge!(other_hash) do |key, first_val, other_val|
        if first_val.is_a?(Hash) && other_val.is_a?(Hash)
          deep_merge(first_val, other_val, &block)
        elsif block
          yield(key, first_val, other_val)
        else
          other_val
        end
      end
    end
  end
end
