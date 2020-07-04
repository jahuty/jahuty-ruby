module Jahuty
  class Snippet
    @get

    class << self
      def render(id, options = {})
        raise "API key not set. Did you use Jahuty.key?" unless Jahuty.key?

        @get ||= Service::Render.new(Service::Connect.new.call(Jahuty.key))

        @get.call(id, options)
      end
    end
  end
end
