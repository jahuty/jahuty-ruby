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

      def method_missing(name, *args, &block)
        if args.empty? && class_name?(name)
          unless @services.key?(name)
            klass   = class_name(name)
            service = Object.const_get(klass).send(:new, client: @client)
            @services[name] = service
          end

          @services[name]
        else
          super
        end
      end

      def respond_to_missing?(name, include_private = false)
        class_name(name) || super
      end

      private

      def class_name(service_name)
        CLASSES[service_name]
      end

      def class_name?(service_name)
        CLASSES.key?(service_name)
      end
    end
  end
end
