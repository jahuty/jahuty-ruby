require "json"

module Jahuty
  class Service::Get
    @connection

    def initialize(connection)
      @connection = connection
    end

    def call(id, params = {})
      response = @connection.get("snippets/#{id}", { params: params })

      payload = JSON.parse(response.body, symbolize_names: true)

      if response.status != 200
        raise Exception::NotOk.new(Data::Problem.from(payload))
      end

      return Data::Snippet.from(payload)
    end
  end
end
