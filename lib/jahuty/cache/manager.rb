# frozen_string_literal: true

module Jahuty
  module Cache
    # Abstracts away differences between cache implementations and fetches the
    # requested action from the cache or API.
    class Manager
      def initialize(cache:, client:, expires_in: nil)
        @client     = client
        @cache      = cache
        @expires_in = expires_in
      end

      def fetch(action, expires_in: nil)
        key   = key action
        value = read key

        if value.nil?
          value = @client.request action
          write key, value, expires_in: expires_in || @expires_in
        end

        value
      end

      private

      def key(action)
        # Guard against caching unsupported actions.
        raise ArgumentError, 'Action must be show' unless action.is_a?(::Jahuty::Action::Show)

        fingerprint = Digest::MD5.new
        fingerprint << "snippets/#{action.id}/render/"
        fingerprint << action.params.to_json

        "jahuty_#{fingerprint.hexdigest}"
      end

      def read(key)
        if @cache.respond_to?(:read)
          @cache.read(key)
        elsif @cache.respond_to?(:get)
          @cache.get(key)
        else
          raise ArgumentError, 'Cache not supported'
        end
      end

      def write(key, value, expires_in:)
        if Object.const_defined?('::ActiveSupport::Cache::Store') &&
           @cache.is_a?(::ActiveSupport::Cache::Store)
          # Setting :race_condition_ttl is very useful in situations where a
          # cache entry is used very frequently and is under heavy load.
          #
          # @see  https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-fetch
          @cache.write(key, value, expires_in: expires_in, race_condition_ttl: 10)
        elsif @cache.respond_to?(:write)
          @cache.write(key, value, expires_in: expires_in)
        elsif @cache.respond_to?(:set)
          @cache.set(key, value, expires_in: expires_in)
        else
          raise ArgumentError, 'Cache not supported'
        end
      end
    end
  end
end
