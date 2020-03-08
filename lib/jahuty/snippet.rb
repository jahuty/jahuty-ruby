module Jahuty
  class Snippet
    @@key
    @@get

    def self.key=(key)
      @@key = key
    end

    def self.get(id)
      raise "API key not set. Did you use key=?" if @@key.nil?

      @@get ||= Service::Get.new(Service::Connect.new.call(@@key))

      snippet = @@get.call(id)

      snippet.to_s
    end
  end
end
