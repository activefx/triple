# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require "triple/version"

Gem::Specification.new do |s|
  s.name          = "triple"
  s.version       = Triple::VERSION
  s.summary       = "Triple: Quickly Bootstrap an Sqlite-backed Entity-Attribute-Value Datastore"
  s.description   = "Quickly bootstrap an Sqlite-backed Entity-Attribute-Value datastore. Useful for rapid data analysis and transformation projects. Requires ActiveRecord."
  s.author        = "Matt Solt"
  s.email         = "mattsolt@gmail.com"
  s.homepage      = "https://github.com/activefx/triple"
  s.license       = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 2.5.0"

  s.add_development_dependency "bundler",           "~> 1.15"
  s.add_development_dependency "rake",              ">= 10.0"
  s.add_development_dependency "rspec",             "~> 3.7"
  s.add_development_dependency "shoulda-matchers",  "~> 3.0"

  s.add_dependency "sqlite3",                       "~> 1.3"
  s.add_dependency "activerecord",                  "~> 5.2"
end
