module Jahuty
  class Snippet
    @@get

    def self.get(id)
      raise "API key not set. Did you use Jahuty.key?" unless Jahuty.key?

      @@get ||= Service::Get.new(Service::Connect.new.call(Jahuty.key))

      @@get.call(id)
    end
  end
end
