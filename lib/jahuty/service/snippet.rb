# frozen_string_literal: true

module Jahuty
  module Service
    # A service for interacting with snippets.
    class Snippet < Base
      def initialize(client:, cache:, expires_in: nil)
        super(client: client)

        @cache = cache
        @expires_in = expires_in
      end

      def render(snippet_id, params: {}, expires_in: nil)
        expires_in ||= @expires_in

        key = cache_key snippet_id: snippet_id, params: params

        render = @cache.read(key)

        @cache.delete key unless render.nil? || cacheable?(expires_in)

        if render.nil?
          params = { params: params.to_json } unless params.empty?
          action = ::Jahuty::Action::Show.new(
            id: snippet_id,
            resource: 'render',
            params: params
          )
          render = @client.request action
          @cache.write key, render, expires_in: expires_in if cacheable?(expires_in)
        end

        render
      end

      private

      def cache_key(snippet_id:, params: {})
        fingerprint = Digest::MD5.new
        fingerprint << "snippets/#{snippet_id}/render/"
        fingerprint << params.to_json

        "jahuty_#{fingerprint.hexdigest}"
      end

      def cacheable?(expires_in)
        expires_in.nil? || expires_in.positive?
      end
    end
  end
end
