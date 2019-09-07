require 'faraday'

module Jahuty
  module Snippet
    module Service
      class Connect
        URL = "https://www.jahuty.com/api/snippets"

        HEADERS  = {
          "Accept":          "application/json;q=0.9,*/*;q=0.8",
          "Accept-Encoding": "gzip, deflate",
          "Content-Type":    "application/json; charset=utf-8",
          "User-Agent":      "Jahuty Ruby client #{::Jahuty::Snippet::VERSION}"
        }

        def call(key)
          Faraday.new(
            url: URL,
            headers: {"Authorization": "Bearer #{key}"}.merge(HEADERS)
          )
        end
      end
    end
  end
end
