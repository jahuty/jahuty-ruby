# frozen_string_literal: true

module Jahuty
  module Request
    # Instantiates a request from an action.
    class Factory
      def call(action)
        if action.is_a?(::Jahuty::Action::Show)
          path = "snippets/#{action.id}/render"
        elsif action.is_a?(::Jahuty::Action::Index)
          path = 'snippets/render'
        else
          raise ArgumentError, "Action is not supported"
        end

        Base.new(
          method: 'get',
          path: path,
          params: action.params
        )
      end
    end
  end
end
