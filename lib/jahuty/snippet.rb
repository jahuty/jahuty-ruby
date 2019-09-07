require "jahuty/snippet/data/problem"
require "jahuty/snippet/data/snippet"
require "jahuty/snippet/exception/not_ok"
require "jahuty/snippet/service/get"
require "jahuty/snippet/service/connect"
require "jahuty/snippet/version"

module Jahuty
  module Snippet
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
