# frozen_string_literal: true

require 'mini_cache'

module Jahuty
  # Executes requests against Jahuty's API and returns resources.
  class Client
    def initialize(api_key:, cache: nil, expires_in: nil)
      @api_key    = api_key
      @cache      = cache || ::MiniCache::Store.new
      @expires_in = expires_in
      @services   = Service::Factory.new(client: self)
    end

    # Allows services to be accessed as properties (e.g., jahuty.snippets).
    def method_missing(name, *args, &block)
      if args.empty? && @services.respond_to?(name)
        @services.send(name)
      else
        super
      end
    end

    def fetch(action, expires_in: nil)
      @manager ||= Cache::Manager.new(
        client: self,
        cache: @cache,
        expires_in: expires_in || @expires_in
      )

      @manager.fetch(action)
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

    def respond_to_missing?(name, include_private = false)
      @services.respond_to?(name, include_private) || super
    end
  end
end
