# frozen_string_literal: true

module Jahuty
  module Resource
    # Instantiates and returns a resource.
    class Factory
      CLASSES = {
        problem: Problem.name,
        render: Render.name
      }.freeze

      def call(resource_name, payload)
        klass = class_name(resource_name.to_sym)

        raise ArgumentError, "#{resource_name} missing" if klass.nil?

        Object.const_get(klass).send(:from, **payload)
      end

      private

      def class_name(resource_name)
        CLASSES[resource_name.to_sym]
      end
    end
  end
end
