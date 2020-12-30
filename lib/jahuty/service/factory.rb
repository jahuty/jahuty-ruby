# frozen_string_literal: true

module Jahuty
  module Service
    # Instantiates the requested service and memoizes it for subsequent
    # requests.
    class Factory
      CLASSES = {
        snippets: Snippet.name
      }.freeze

      def initialize(client:)
        @client   = client
        @services = {}
      end

      def method_missing(name, *arguments)
        return unless arguments.empty?

        service_name = name.to_sym

        unless @services.key?(service_name)
          service_class = class_name(service_name)
          service = Object.const_get(service_class).send(:new, client: @client)
          @services[service_name] = service
        end

        @services[service_name]
      end

      def respond_to_missing?(name, include_private = false)
        CLASSES.key?(name) || super
      end

      private

      def class_name(service_name)
        raise ArgumentError, "Service '#{service_name}' not found" unless CLASSES.key?(service_name)

        CLASSES[service_name]
      end
    end
  end
end
