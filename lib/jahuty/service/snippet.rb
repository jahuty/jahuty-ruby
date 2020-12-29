module Jahuty
  module Service
    class Snippet < Base
      def render(id, options = {})
        unless options[:params].nil?
          params = { params: options[:params].to_json }
        end

        action = ::Jahuty::Action::Show.new(
          id:       id,
          resource: 'render',
          params:   params || {}
        )

        @client.request(action)
      end
    end
  end
end
