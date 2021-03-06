# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_google/version'

Gem::Specification.new do |spec|
  spec.name          = "the_google"
  spec.version       = TheGoogle::VERSION
  spec.authors       = ["Darren Cauthon"]
  spec.email         = ["darren@cauthon.com"]
  spec.summary       = %q{Helpers around a google integration.}
  spec.description   = %q{Helpers around a google integration.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "timecop"

  spec.add_runtime_dependency 'google-api-client'
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'interchangeable'
end
