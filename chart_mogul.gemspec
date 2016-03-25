# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chart_mogul/version'

Gem::Specification.new do |spec|
  spec.name          = "chart_mogul"
  spec.version       = ChartMogul::VERSION
  spec.authors       = ["Adam Bird"]
  spec.email         = ["adam.bird@gmail.com"]

  spec.summary       = %q{Gem for working with the ChartMogul API}
  spec.homepage      = "https://github.com/adambird/chart-mogul-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", "~> 0.9"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end
