module Jahuty
  module Exception
    class Error < ::StandardError
      attr_reader :problem

      def initialize(problem)
        @problem = problem
      end

      def message
        "The API responded with #{@problem.status}, #{@problem.type}: #{@problem.detail}"
      end
    end
  end
end
