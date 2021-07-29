# frozen_string_literal: true

module Jahuty
  module Service
    # A service for interacting with snippets.
    class Snippet < Base
      def initialize(client:, cache:, expires_in: nil, prefer_latest: false)
        super(client: client)

        @cache = cache
        @expires_in = expires_in
        @prefer_latest = prefer_latest
      end

      def all_renders(tag, params: {}, expires_in: @expires_in, prefer_latest: @prefer_latest)
        renders = index_renders tag: tag, params: params, prefer_latest: prefer_latest

        cache_renders renders: renders, params: params, expires_in: expires_in, latest: prefer_latest

        renders
      end

      def render(snippet_id, params: {}, expires_in: @expires_in, prefer_latest: @prefer_latest, location: nil)
        key = cache_key snippet_id: snippet_id, params: params, latest: prefer_latest

        render = @cache.read key

        @cache.delete key unless render.nil? || cacheable?(expires_in)

        if render.nil?
          render = show_render snippet_id: snippet_id, params: params, prefer_latest: prefer_latest, location: location

          @cache.write key, render, expires_in: expires_in if cacheable?(expires_in)
        end

        render
      end

      private

      def cache_key(snippet_id:, params: {}, latest: false)
        fingerprint = Digest::MD5.new
        fingerprint << "snippets/#{snippet_id}/render/"
        fingerprint << params.to_json
        fingerprint << '/latest' if latest

        "jahuty_#{fingerprint.hexdigest}"
      end

      def cache_renders(renders:, params:, expires_in: @expires_in, latest: false)
        return if renders.nil?

        return unless cacheable?(expires_in)

        global_params = params['*'] || {}

        renders.each do |render|
          local_params = params[render.snippet_id.to_s] || {}
          render_params = ::Jahuty::Util.deep_merge global_params, local_params

          key = cache_key snippet_id: render.snippet_id, params: render_params, latest: latest

          @cache.write key, render, expires_in: expires_in
        end
      end

      def cacheable?(expires_in)
        expires_in.nil? || expires_in.positive?
      end

      def index_renders(tag:, params: {}, prefer_latest: false)
        request_params = { tag: tag }
        request_params[:params] = params.to_json unless params.empty?
        request_params[:latest] = 1 if prefer_latest

        action = ::Jahuty::Action::Index.new(
          resource: 'render',
          params: request_params
        )

        @client.request action
      end

      def show_render(snippet_id:, params: {}, prefer_latest: false, location: nil)
        request_params = {}
        request_params[:params] = params.to_json unless params.empty?
        request_params[:latest] = 1 if prefer_latest
        request_params[:location] = location unless location.nil?

        action = ::Jahuty::Action::Show.new(
          id: snippet_id,
          resource: 'render',
          params: request_params
        )

        @client.request action
      end
    end
  end
end
