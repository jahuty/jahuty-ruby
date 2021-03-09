# frozen_string_literal: true

require 'json'

module Jahuty
  module Response
    # Inspects the response and returns the appropriate resource or collection.
    class Handler
      def call(action, response)
        resource_name = name_resource action, response

        payload = parse response

        @resources ||= ::Jahuty::Resource::Factory.new

        if collection?(action, payload)
          payload.map { |data| @resources.call resource_name, data }
        elsif resource?(action, payload)
          @resources.call resource_name, payload
        else
          raise ArgumentError, 'Action and payload mismatch'
        end
      end

      private

      def collection?(action, payload)
        action.is_a?(Action::Index) && payload.is_a?(::Array)
      end

      def name_resource(action, response)
        if success? response
          action.resource
        elsif problem? response
          'problem'
        else
          raise ArgumentError, 'Unexpected response'
        end
      end

      def parse(response)
        JSON.parse(response.body, symbolize_names: true)
      end

      def problem?(response)
        response.headers['Content-Type'].include?('application/problem+json') &&
          (response.status < 200 || response.status >= 300)
      end

      def resource?(action, payload)
        !action.is_a?(Action::Index) && payload.is_a?(::Object)
      end

      def success?(response)
        response.headers['Content-Type'].include?('application/json') &&
          response.status.between?(200, 299)
      end
    end
  end
end
