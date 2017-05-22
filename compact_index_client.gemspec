# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "compact_index_client/version"

Gem::Specification.new do |spec|
  spec.name          = "compact_index_client"
  spec.version       = CompactIndexClient::VERSION
  spec.authors       = ["Samuel E. Giddins"]
  spec.email         = ["segiddins@segiddins.me"]

  spec.summary       = "The client for the new Bundler compact index format."
  spec.homepage      = "https://github.com/bundler/compact_index_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.post_install_message = "This gem is deprecated and is no longer supported by the Bundler team."

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
