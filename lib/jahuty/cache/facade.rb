# frozen_string_literal: true

module Jahuty
  module Cache
    # Abstracts away the differences in cache implementation methods and
    # argument lists.
    class Facade
      def initialize(cache)
        @cache = cache
      end

      def delete(key)
        if @cache.respond_to? :delete
          @cache.delete key
        elsif @cache.respond_to? :unset
          @cache.unset key
        else
          raise NoMethodError, 'Cache must respond to :delete or :unset'
        end
      end

      def read(key)
        if @cache.respond_to? :read
          @cache.read key
        elsif @cache.respond_to? :get
          @cache.get key
        else
          raise NoMethodError, 'Cache must respond to :read or :get'
        end
      end

      def write(key, value, expires_in: nil)
        if Object.const_defined?('::ActiveSupport::Cache::Store') &&
           @cache.is_a?(::ActiveSupport::Cache::Store)
          @cache.write key, value, expires_in: expires_in, race_condition_ttl: 10
        elsif @cache.respond_to? :write
          @cache.write key, value, expires_in: expires_in
        elsif @cache.respond_to? :set
          @cache.set key, value, expires_in: expires_in
        else
          raise NoMethodError, 'Cache must respond to :write or :set'
        end
      end
    end
  end
end
