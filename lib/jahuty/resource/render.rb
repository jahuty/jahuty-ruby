# frozen_string_literal: true

module Jahuty
  module Resource
    # A snippet's rendered content.
    class Render
      attr_accessor :content, :snippet_id

      def initialize(content:, snippet_id:)
        @content = content
        @snippet_id = snippet_id
      end

      def self.from(data)
        raise ArgumentError.new, 'Key :content missing' unless data.key?(:content)
        raise ArgumentError.new, 'Key :snippet_id missing' unless data.key?(:snippet_id)

        Render.new(data.slice(:content, :snippet_id))
      end

      def to_s
        @content
      end
    end
  end
end
