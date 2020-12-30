# frozen_string_literal: true

module Jahuty
  module Action
    class Show < Base
      attr_accessor :id

      def initialize(resource:, id:, params: {})
        @id = id

        super(resource: resource, params: params)
      end
    end
  end
end
