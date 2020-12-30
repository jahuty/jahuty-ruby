# frozen_string_literal: true

module Jahuty
  module Request
    # Provides common logic for all requests.
    class Base
      attr_accessor :method, :path, :params

      def initialize(method:, path:, params: {})
        @method = method
        @path   = path
        @params = params
      end
    end
  end
end
