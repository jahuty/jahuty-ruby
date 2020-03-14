module Jahuty
  class Snippet
    @get

    class << self
      def get(id, params = {})
        raise "API key not set. Did you use Jahuty.key?" unless Jahuty.key?

        @get ||= Service::Get.new(Service::Connect.new.call(Jahuty.key))

        @get.call(id, params)
      end
    end
  end
end
