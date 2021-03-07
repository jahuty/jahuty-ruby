# frozen_string_literal: true

require 'mini_cache'

module Jahuty
  # Executes requests against Jahuty's API and returns resources.
  class Client
    def initialize(api_key:, cache: nil, expires_in: nil)
      @api_key    = api_key
      @cache      = Cache::Facade.new(cache || ::MiniCache::Store.new)
      @expires_in = expires_in
      @services   = {}
    end

    # Allows services to be accessed as properties (e.g., jahuty.snippets).
    def method_missing(name, *args, &block)
      if args.empty? && name == :snippets
        unless @services.key?(name)
          @services[name] = Service::Snippet.new(
            client: self,
            cache: @cache,
            expires_in: @expires_in
          )
        end
        @services[name]
      else
        super
      end
    end

    def request(action)
      @requests ||= Request::Factory.new

      request = @requests.call(action)

      @client ||= Api::Client.new(api_key: @api_key)

      response = @client.send(request)

      @responses ||= Response::Handler.new

      result = @responses.call(action, response)

      raise Exception::Error.new(result), 'API problem' if result.is_a?(Resource::Problem)

      result
    end

    def respond_to_missing?(name, include_private = false)
      name == :snippets || super
    end
  end
end
