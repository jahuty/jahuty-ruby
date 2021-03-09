# frozen_string_literal: true

module Jahuty
  module Request
    # Instantiates a request from an action.
    class Factory
      def call(action)
        Base.new(
          method: 'get',
          path: path(action),
          params: action.params
        )
      end

      private

      def path(action)
        case action
        when ::Jahuty::Action::Show
          "snippets/#{action.id}/render"
        when ::Jahuty::Action::Index
          'snippets/render'
        else
          raise ArgumentError, 'Action is not supported'
        end
      end
    end
  end
end
