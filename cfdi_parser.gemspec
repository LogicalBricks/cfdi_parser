# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cfdi_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "cfdi_parser"
  spec.version       = CfdiParser::VERSION
  spec.authors       = ["thotmx"]
  spec.email         = ["hermes.ojeda@logicalbricks.com"]
  spec.summary       = %q{CFDI parser for official invoices in México.}
  spec.description   = %q{CFDI parser to get all the information from the Mexico's electronic invoices.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"

  spec.add_dependency 'nokogiri'
end
