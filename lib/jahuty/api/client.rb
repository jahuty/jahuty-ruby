# frozen_string_literal: true

require "faraday"

module Jahuty
  module Api
    class Client
      HEADERS = {
        'Accept'          => 'application/json;q=0.9,*/*;q=0.8',
        'Accept-Encoding' => 'gzip, deflate',
        'Content-Type'    => 'application/json; charset=utf-8',
        'User-Agent'      => "Jahuty Ruby SDK v#{::Jahuty::VERSION}"
      }

      def initialize(api_key:)
        @api_key  = api_key
      end

      def send(request)
        @client = Faraday.new(
          url:     ::Jahuty::BASE_URI,
          headers: headers
        ) if @client.nil?

        @client.send(
          request.method.to_sym,
          request.path,
          { params: request.params }
        )
      end

      private

      def headers
        { 'Authorization' => "Bearer #{@api_key}" }.merge(HEADERS)
      end
    end
  end
end
