# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/oauth2/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-auth"
  spec.version       = "0.0.1"
  spec.authors       = ["Nathaniel Symer"]
  spec.email         = ["nate@natesymer.com"]
  spec.summary       = "Rackish authentication for Rack apps."
  spec.description   = spec.summary + " " + "Provides access to the `Authorization` HTTP header."
  spec.homepage      = "https://github.com/sansomrb/rack-auth"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
