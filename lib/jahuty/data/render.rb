module Jahuty
  module Data
    class Render
      attr_accessor :id, :content

      def initialize(id, content)
        @id      = id
        @content = content
      end

      def self.from(data)
        raise ArgumentError.new "Key :id does not exist" if !data.key?(:id)
        raise ArgumentError.new "Key :content does not exist" if !data.key?(:content)

        Render.new(data[:id], data[:content])
      end

      def to_s
        @content
      end
    end
  end
end
