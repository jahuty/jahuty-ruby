require 'json'

module Jahuty
  module Snippet
    module Service
      class Get
        @connection

        def initialize(connection)
          @connection = connection

        end

        def call(id)
          response = @connection.get(id.to_s)

          payload = JSON.parse(response.body, symbolize_names: true)

          if response.status != 200
            raise ::Jahuty::Snippet::Exception::NotOk.new(
              ::Jahuty::Snippet::Data::Problem.from(payload)
            )
          end

          return ::Jahuty::Snippet::Data::Snippet.from(payload)
        end
      end
    end
  end
end
