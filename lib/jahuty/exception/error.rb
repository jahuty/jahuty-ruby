# frozen_string_literal: true

module Jahuty
  module Exception
    # Thrown when a client- or server-error occurs.
    class Error < ::StandardError
      attr_reader :problem

      def initialize(problem)
        @problem = problem

        super
      end

      def message
        "The API responded with #{@problem.status}, #{@problem.type}: #{@problem.detail}"
      end
    end
  end
end
