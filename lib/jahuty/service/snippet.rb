# frozen_string_literal: true

module Jahuty
  module Service
    # A service for interacting with snippets.
    class Snippet < Base
      def render(id, params: {}, expires_in: nil)
        params = { params: params.to_json } unless params.empty?

        action = ::Jahuty::Action::Show.new(id: id, resource: 'render', params: params)

        @client.fetch action, expires_in: expires_in
      end
    end
  end
end
