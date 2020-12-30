# frozen_string_literal: true

module Jahuty
  class Client
    @api_key

    @client

    @requests

    @resources

    @services

    def initialize (api_key:)
      @api_key = api_key
    end

    def method_missing(name, *arguments)
      if arguments.empty?
        @services = Service::Factory.new(client: self) if @services.nil?

        @services.send(name.to_sym)
      end
    end

    def request(action)
      @requests = Request::Factory.new if @requests.nil?

      request = @requests.call(action)

      @client =  Api::Client.new(api_key: @api_key) if @client.nil?

      response = @client.send(request)

      @resources = Resource::Factory.new if @resources.nil?

      resource = @resources.call(action, response)

      raise Exception::Error.new(resource) if resource.is_a?(Resource::Problem)

      resource
    end
  end
end
