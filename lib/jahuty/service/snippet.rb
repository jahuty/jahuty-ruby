# frozen_string_literal: true

module Jahuty
  module Service
    # A service for interacting with snippets.
    class Snippet < Base
      def render(id, options = {})
        params = { params: options[:params].to_json } unless options[:params].nil?

        action = ::Jahuty::Action::Show.new(
          id: id,
          resource: 'render',
          params: params || {}
        )

        @client.request(action)
      end
    end
  end
end
