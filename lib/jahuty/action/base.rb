# frozen_string_literal: true

module Jahuty
  module Action
    # Provides common logic for service actions.
    class Base
      attr_accessor :resource, :params

      def initialize(resource:, params: {})
        @resource = resource
        @params   = params
      end
    end
  end
end
