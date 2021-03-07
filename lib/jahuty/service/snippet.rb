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

      def all_renders(tag, params: {}, expires_in: nil)
        expires_in ||= @expires_in

        request_params = { tag: tag }
        request_params[:params] = params.to_json unless params.empty?

        action = ::Jahuty::Action::Index.new(
          resource: 'render',
          params: request_params
        )

        renders = @client.request action

        if cacheable?(expires_in)
          global_params = params['*'] || {}

          renders.each do |render|
            local_params = params[render.snippet_id.to_s] || {}
            render_params = global_params.deep_merge(local_params)

            key = cache_key(snippet_id: render.snippet_id, params: render_params)

            @cache.write key, render, expires_in: expires_in
          end
        end

        renders
      end

      def render(snippet_id, params: {}, expires_in: nil)
        expires_in ||= @expires_in

        key = cache_key snippet_id: snippet_id, params: params

        render = @cache.read(key)

        @cache.delete key unless render.nil? || cacheable?(expires_in)

        if render.nil?
          request_params = {}
          request_params[:params] = params.to_json unless params.empty?

          action = ::Jahuty::Action::Show.new(
            id: snippet_id,
            resource: 'render',
            params: request_params
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
