# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'niman/version'

Gem::Specification.new do |spec|
  spec.name          = "niman"
  spec.version       = Niman::VERSION
  spec.authors       = ["Jan Schulte"]
  spec.email         = ["hello@unexpected-co.de"]
  spec.summary       = %q{Provisions your machine}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency "virtus", "~> 1.0.4"
  spec.add_development_dependency "rspec", "3.1"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
