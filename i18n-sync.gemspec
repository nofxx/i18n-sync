lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'i18n/sync/version'

Gem::Specification.new do |s|
  s.name = "i18n-sync"
  s.version = I18n::Sync::VERSION
  s.platform = Gem::Platform::RUBY

  s.authors     = ["Marcos Piccinini"]
  s.homepage    = %q{http://github.com/nofxx/i18n-sync}
  s.email       = "x@nofxx.com"
  s.summary     = %q{Syncs all locale yml/rb files based on a "master" one.}
  s.description = %q{Gem to sync all locale yml/rb files based on a "master" one.}
  s.license     = 'MIT'

  s.executables = ["i18s"]
  s.default_executable = %q{i18s}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency('thor', [">= 0"])
end
