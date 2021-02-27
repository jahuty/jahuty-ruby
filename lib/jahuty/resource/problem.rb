# frozen_string_literal: true

module Jahuty
  module Resource
    # An application/problem+json response. The API should respond with a
    # problem whenever a client- or server-error occurs.
    class Problem
      attr_accessor :status, :type, :detail

      def initialize(status:, type:, detail:)
        @status = status
        @type   = type
        @detail = detail
      end

      def self.from(data)
        raise ArgumentError.new "Key :status missing" if !data.key?(:status)
        raise ArgumentError.new "Key :type missing" if !data.key?(:type)
        raise ArgumentError.new "Key :detail missing" if !data.key?(:detail)

        Problem.new(data.slice(:status, :type, :detail))
      end
    end
  end
end
