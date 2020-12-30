# frozen_string_literal: true

module Jahuty
  module Resource
    # A snippet's rendered content. Remember, renders are unique by the
    # combination of id and params (i.e., the same id can produce different
    # renders with different params).
    class Render
      attr_accessor :content

      def initialize(content:)
        @content = content
      end

      def to_s
        @content
      end
    end
  end
end
