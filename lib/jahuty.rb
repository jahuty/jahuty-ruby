# frozen_string_literal: true

require 'jahuty/version'

require 'jahuty/action/base'
require 'jahuty/action/index'
require 'jahuty/action/show'

require 'jahuty/api/client'

require 'jahuty/cache/facade'

require 'jahuty/exception/error'

require 'jahuty/request/base'
require 'jahuty/request/factory'

require 'jahuty/resource/problem'
require 'jahuty/resource/render'
require 'jahuty/resource/factory'

require 'jahuty/response/handler'

require 'jahuty/service/base'
require 'jahuty/service/snippet'

require 'jahuty/client'

module Jahuty
  BASE_URI = 'https://api.jahuty.com'
end
