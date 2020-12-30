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
    end
  end
end
