# frozen_string_literal: true

module Jahuty
  module Service
    class Factory
      CLASSES = {
        snippets: Snippet.name
      }

      def initialize(client:)
        @client   = client
        @services = {}
      end

      def method_missing(name, *arguments)
        if arguments.empty?
          service_name = name.to_sym

          unless @services.key?(service_name)
            service_class = class_name(service_name)
            service = Object.const_get(service_class).send(:new, client: @client)
            @services[service_name] = service
          end

          @services[service_name]
        end
      end

      private

      def class_name(service_name)
        raise ArgumentError.new(
          "Service '#{service_name}' not found"
        ) unless CLASSES.key?(service_name)

        CLASSES[service_name]
      end
    end
  end
end
