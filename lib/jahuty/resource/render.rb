# frozen_string_literal: true

module Jahuty
  module Resource
    # A snippet's rendered content.
    class Render
      attr_accessor :content

      def initialize(content:)
        @content = content
      end

      def self.from(data)
        raise ArgumentError.new, 'Key :content missing' unless data.key?(:content)

        Render.new(data.slice(:content))
      end

      def to_s
        @content
      end
    end
  end
end
