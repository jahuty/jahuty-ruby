
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jahuty/version'

Gem::Specification.new do |spec|
  spec.name          = 'jahuty'
  spec.version       = Jahuty::VERSION
  spec.authors       = ['Jack Clayton']
  spec.email         = ['jack@jahuty.com']

  spec.summary       = %q{Jahuty's Ruby SDK.}
  spec.description   = %q{Turn any page into a content-managed page.}
  spec.homepage      = 'https://www.jahuty.com'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/jahuty/jahuty-ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/jahuty/jahuty-ruby/blob/master/CHANGELOG.md'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.11'
  spec.add_development_dependency 'rspec_junit_formatter', '~>0.4'
  spec.add_development_dependency 'rubocop', '~> 1.7'
  spec.add_development_dependency 'rubocop-performance', '~> 1.9'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.1'
end
