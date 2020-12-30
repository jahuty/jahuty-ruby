# frozen_string_literal: true

module Jahuty
  module Action
    class Base
      attr_accessor :resource, :params

      def initialize(resource:, params: {})
        @resource = resource
        @params   = params
      end
    end
  end
end
