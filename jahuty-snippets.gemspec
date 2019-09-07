
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jahuty/snippet/version"

Gem::Specification.new do |spec|
  spec.name          = "jahuty-snippet"
  spec.version       = Jahuty::Snippet::VERSION
  spec.authors       = ["Jack Clayton"]
  spec.email         = ["jack@jahuty.com"]

  spec.summary       = %q{Jahuty's API client.}
  spec.description   = %q{Turn any page into a content-managed page.}
  spec.homepage      = "https://github.com/jahuty/snippets-ruby"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', '~> 0.1'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
