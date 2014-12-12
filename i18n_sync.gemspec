lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'i18n/sync/version'

Gem::Specification.new do |gem|
  gem.name = "i18n-sync"
  gem.version = I18n::Sync::VERSION

  gem.authors = ["Marcos Piccinini"]
  gem.homepage = %q{http://github.com/nofxx/i18n_sync}
  gem.summary = %q{Syncs all locale yml/rb files based on a "master" one.}
  gem.email = "x@nofxx.com"
  gem.description = %q{Gem to sync all locale yml/rb files based on a "master" one.}

  gem.executables = ["i18s"]
  gem.default_executable = %q{i18s}

  gem.files = Dir.glob("{lib,spec}/**/*") + %w(README.md Rakefile)
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_path = "lib"


  gem.add_dependency('ya2yaml', [">= 0"])
  gem.add_development_dependency("rspec", ["~> 2.8.0"])
end
