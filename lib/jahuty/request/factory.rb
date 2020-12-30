# frozen_string_literal: true

module Jahuty
  module Request
    # Instantiates a request from an action. Currently, this is elementary. As
    # we add actions, it will become more complicated.
    class Factory
      def call(action)
        Base.new(
          method: 'get',
          path: "snippets/#{action.id}/render",
          params: action.params
        )
      end
    end
  end
end
