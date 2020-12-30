# frozen_string_literal: true

module Jahuty
  module Action
    # Displays a specific resource.
    class Show < Base
      attr_accessor :id

      def initialize(resource:, id:, params: {})
        @id = id

        super(resource: resource, params: params)
      end
    end
  end
end
