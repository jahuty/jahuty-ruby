# frozen_string_literal: true

module Jahuty
  module Resource
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
