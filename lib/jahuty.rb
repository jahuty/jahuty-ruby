require "jahuty/version"

require "jahuty/snippet"

require "jahuty/data/problem"
require "jahuty/data/snippet"

require "jahuty/exception/not_ok"

require "jahuty/service/connect"
require "jahuty/service/render"

module Jahuty
  @key

  class << self
    attr_accessor :key

    def key?
      !(@key.nil? || @key.empty?)
    end
  end
end
