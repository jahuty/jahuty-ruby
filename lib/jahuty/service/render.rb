require "json"

module Jahuty
  class Service::Render
    @connection

    def initialize(connection)
      @connection = connection
    end

    def call(id, options = {})
      settings = { params: options[:params].to_json } unless options[:params].nil?

      response = @connection.get("snippets/#{id}/render", settings || {})

      payload = JSON.parse(response.body, symbolize_names: true)

      if response.status != 200
        raise Exception::NotOk.new(Data::Problem.from(payload))
      end

      return Data::Render.from(payload)
    end
  end
end
