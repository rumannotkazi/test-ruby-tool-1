# frozen_string_literal: true
begin
    require 'git-version-bump'
rescue LoadError
    # do nothing
else
    
end
Gem::Specification.new do |spec|
    spec.name          = "tool-1"
    spec.version       = defined?(GVB) ? GVB.version : "0.0.1"
    spec.authors       = ["Ruman Kazi"]
    spec.email         = ["rkazi@xccelerated.com"]
    spec.summary       = "Tool 1"
    spec.description   = "Tool 1 for testing"
    
    spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
    spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
    spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
    spec.require_paths = ["lib"]
    
    spec.add_dependency "tool-2", "~> 0.0.1"
    spec.add_development_dependency "bundler", "1.16"
    spec.add_development_dependency "rake", "~> 12.3", ">= 12.3.1"
    spec.add_development_dependency "rspec", "= 3.8"
    spec.add_development_dependency "rubocop", "~> 0.59.2"
  end