require "json"

module Jahuty
  module Resource
    class Factory
      CLASSES = {
        problem: Problem.name,
        render:  Render.name
      }

      def call(action, response)
        if success? response
          resource_name = action.resource
        elsif problem? response
          resource_name = 'problem'
        else
          raise ArgumentError.new("Unexpected response")
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
        response.headers["Content-Type"] == "application/problem+json"
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
