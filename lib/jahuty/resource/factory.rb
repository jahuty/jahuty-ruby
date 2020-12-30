# frozen_string_literal: true

require 'json'

module Jahuty
  module Resource
    # Negotiates the resource to return given the requested action and the
    # server's response.
    class Factory
      CLASSES = {
        problem: Problem.name,
        render: Render.name
      }.freeze

      def call(action, response)
        if success? response
          resource_name = action.resource
        elsif problem? response
          resource_name = 'problem'
        else
          raise ArgumentError, 'Unexpected response'
        end

        resource_class = class_name(resource_name.to_sym)

        payload = parse(response)

        Object.const_get(resource_class).send(:new, **payload)
      end

      private

      def class_name(resource_name)
        CLASSES[resource_name.to_sym]
      end

      def problem?(response)
        response.headers['Content-Type'] == 'application/problem+json'
      end

      def parse(response)
        JSON.parse(response.body, symbolize_names: true)
      end

      def success?(response)
        response.status.between?(200, 299)
      end
    end
  end
end
