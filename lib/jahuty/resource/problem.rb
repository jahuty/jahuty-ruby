module Jahuty
  module Resource
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
