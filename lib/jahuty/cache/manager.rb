# frozen_string_literal: true

module Jahuty
  module Cache
    # Fetches the requested action from the cache or API.
    class Manager
      def initialize(cache:, client:, expires_in: nil)
        @client     = client
        @cache      = Facade.new(cache)
        @expires_in = expires_in
      end

      def fetch(action, expires_in: nil)
        key   = key action
        value = @cache.read key

        @cache.delete key unless value.nil? || cacheable(expires_in)

        if value.nil?
          value = @client.request action
          @cache.write key, value, expires_in: expires_in || @expires_in if cacheable(expires_in)
        end

        value
      end

      private

      def cacheable(expires_in)
        expires_in.nil? || expires_in.positive?
      end

      def key(action)
        # We only build cache keys for show-render actions at this time.
        unless action.is_a?(::Jahuty::Action::Show) && action.resource == 'render'
          raise ArgumentError, 'Action must be show render'
        end

        fingerprint = Digest::MD5.new
        fingerprint << "snippets/#{action.id}/render/"
        fingerprint << action.params.to_json

        "jahuty_#{fingerprint.hexdigest}"
      end
    end
  end
end
