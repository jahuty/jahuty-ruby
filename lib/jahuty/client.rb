# frozen_string_literal: true

module Jahuty
  # Executes requests against Jahuty's API and returns resources.
  class Client
    def initialize(api_key:)
      @api_key = api_key
    end

    # Allows services to appear as properties (e.g., jahuty.snippets).
    def method_missing(name, *arguments)
      return unless arguments.empty?

      @services ||= Service::Factory.new(client: self)

      @services.send(name.to_sym)
    end

    def respond_to_missing?(name, include_private = false)
      Service::Factory.response_to_missing?(name, include_private) || super
    end

    def request(action)
      @requests ||= Request::Factory.new

      request = @requests.call(action)

      @client ||= Api::Client.new(api_key: @api_key)

      response = @client.send(request)

      @resources ||= Resource::Factory.new

      resource = @resources.call(action, response)

      raise Exception::Error.new(resource), 'API responded with a problem' if resource.is_a?(Resource::Problem)

      resource
    end
  end
end
