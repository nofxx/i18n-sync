lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'i18n_sync'

Gem::Specification.new do |gem|
  gem.name = "i18n_sync"
  gem.version = I18S::VERSION

  gem.authors = ["Marcos Piccinini"]
  gem.homepage = %q{http://github.com/nofxx/i18n_sync}
  gem.summary = %q{Syncs all locale yml/rb files based on a "master" one.}
  gem.email = "x@nofxx.com"
  gem.description = %q{Gem to sync all locale yml/rb files based on a "master" one.}
  gem.executables = ["i18s"]

  gem.files = Dir.glob("{lib,spec}/**/*") + %w(README.md Rakefile)
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.require_path = "lib"
  gem.default_executable = %q{i18s}

  gem.rubygems_version = "1.3.7"

  gem.required_rubygems_version = Gem::Requirement.new(">= 0") if gem.respond_to? :required_rubygems_version=

  gem.add_dependency('ya2yaml', [">= 0"])
  gem.add_development_dependency("rspec", ["~> 2.8.0"])
end
