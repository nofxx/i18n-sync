lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'i18n_sync'

Gem::Specification.new do |s|
  s.name = "i18n_sync"
  s.version = I18S::VERSION

  s.authors = ["Marcos Piccinini"]
  s.homepage = %q{http://github.com/nofxx/i18n_sync}
  s.summary = %q{Syncs all locale yml/rb files based on a "master" one.}
  s.email = "x@nofxx.com"
  s.description = %q{Gem to sync all locale yml/rb files based on a "master" one.}
  s.executables = ["i18s"]

  s.files = Dir.glob("{lib,spec}/**/*") + %w(README.md Rakefile)
  s.require_path = "lib"
  s.default_executable = %q{i18s}

  s.rubygems_version = "1.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.add_development_dependency("i18n", ["~> 0.6.0"])
  s.add_development_dependency("rspec", ["~> 2.8.0"])
  s.add_development_dependency("mongoid", ["~> 2.3.0"])
  s.add_development_dependency("bson_ext", ["~> 1.5.0"])
  s.add_development_dependency("sqlite3", ["~> 1.3.0"])
  s.add_development_dependency("pg", ["~> 0.12.2"])
  s.add_development_dependency("activerecord", ["~> 3.1.0"])
end
