# frozen_string_literal: true

module Jahuty
  module Service
    class Base
      @client

      def initialize(client:)
        @client = client
      end
    end
  end
end
