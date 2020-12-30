module Jahuty
  module Request
    class Factory
      def call(action)
        Base.new(
          method: 'get',
          path:   "snippets/#{action.id}/render",
          params: action.params
        )
      end
    end
  end
end
