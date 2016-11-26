# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'schema_plus/pg_types/version'

Gem::Specification.new do |gem|
  gem.name          = "schema_plus_pg_types"
  gem.version       = SchemaPlus::PgTypes::VERSION
  gem.authors       = ["Boaz Yaniv"]
  gem.email         = ["boazyan@gmail.com"]
  gem.summary       = %q{Adds supports for PostgreSQL types that were left out by Rails}
  gem.homepage      = "https://github.com/SchemaPlus/schema_plus_pg_types"
  gem.license       = "MIT"

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "activerecord", "~> 5.0"
  gem.add_dependency "schema_plus_core", "~> 2.0", ">= 2.0.1"

  gem.add_development_dependency "bundler", "~> 1.7"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "schema_dev", "~> 3.7", ">= 3.7.1"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "simplecov-gem-profile"
end
