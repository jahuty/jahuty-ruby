# frozen_string_literal: true

module Jahuty
  module Cache
    # Fetches requested actions from the cache or the API.
    class Manager
      def initialize(cache:, client:, expires_in: nil)
        @client     = client
        @cache      = cache
        @expires_in = expires_in
      end

      def fetch(action, expires_in: nil)
        key = cache_key(action)

        value = @cache.read(key)

        if value.nil?
          value = @client.request(action)
          expires_in ||= @expires_in
          @cache.write(key, value, expires_in: expires_in, race_condition_ttl: 10)
        end

        value
      end

      private

      def cache_key(action)
        # Guard against caching unsupported actions.
        raise ArgumentError, 'Action must be show' unless action.is_a?(::Jahuty::Action::Show)

        fingerprint = Digest::MD5.new
        fingerprint << "snippets/#{action.id}/render/"
        fingerprint << action.params.to_json

        "jahuty_#{fingerprint.hexdigest}"
      end
    end
  end
end
