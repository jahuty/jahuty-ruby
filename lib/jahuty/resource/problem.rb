module Jahuty
  module Resource
    class Problem
      attr_accessor :status, :type, :detail

      def initialize(status:, type:, detail:)
        @status = status
        @type   = type
        @detail = detail
      end

      def self.from(payload)
        Problem.new(**payload)
      end
    end
  end
end
