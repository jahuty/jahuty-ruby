require "json"

module Jahuty
  class Service::Get
    @connection

    def initialize(connection)
      @connection = connection
    end

    def call(id, params = {})
      options = { params: params.to_json } if !params.empty?

      response = @connection.get("snippets/#{id}", options || {})

      payload = JSON.parse(response.body, symbolize_names: true)

      if response.status != 200
        raise Exception::NotOk.new(Data::Problem.from(payload))
      end

      return Data::Snippet.from(payload)
    end
  end
end
