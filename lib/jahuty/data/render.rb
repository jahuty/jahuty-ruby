module Jahuty
  module Data
    class Render
      attr_accessor :content

      def initialize(content)
        @content = content
      end

      def self.from(data)
        raise ArgumentError.new "Key :content does not exist" if !data.key?(:content)

        Render.new(data[:content])
      end

      def to_s
        @content
      end
    end
  end
end
