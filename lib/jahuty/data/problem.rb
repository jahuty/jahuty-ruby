module Jahuty
  module Data
    class Problem
      attr_accessor :status, :type, :detail

      def initialize(status, type, detail)
        @status = status
        @type   = type
        @detail = detail
      end

      def self.from(data)
        raise ArgumentError.new "Key :status does not exist" if !data.key?(:status)
        raise ArgumentError.new "Key :type does not exist" if !data.key?(:type)
        raise ArgumentError.new "Key :detail does not exist" if !data.key?(:detail)

        Problem.new(data[:status], data[:type], data[:detail])
      end
    end
  end
end
