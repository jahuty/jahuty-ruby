# frozen_string_literal: true

module Jahuty
  module Service
    # Provides common logic to services.
    class Base
      def initialize(client:)
        @client = client
      end
    end
  end
end
