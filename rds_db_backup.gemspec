# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rds_db_backup/version'

Gem::Specification.new do |spec|
  spec.name          = "rds_db_backup"
  spec.version       = RdsDbBackup::VERSION
  spec.authors       = ["Kristijonas Urbaitis"]
  spec.email         = ["kristijonas.urbaitis@gmail.com"]

  spec.summary       = %q{Gem for easy AWS RDS DB backups}
  spec.description   = %q{This gem allows to create DB backups in a way that does not block the production RDS instance}
  spec.homepage      = "https://github.com/kurbaitis/rds_db_backup"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
