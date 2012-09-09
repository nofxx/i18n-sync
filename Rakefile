require 'bundler'
Bundler.setup
require 'rspec/core/rake_task'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "i18n_sync"

desc "Builds the gem"
task :gem => :build
task :build do
  system "gem build i18n_sync.gemspec"
  Dir.mkdir("pkg") unless Dir.exists?("pkg")
  system "mv i18n_sync-#{I18S::VERSION}.gem pkg/"
end

task :install => :build do
  system "sudo gem install pkg/i18n_sync-#{I18S::VERSION}.gem"
end

desc "Release the gem - Gemcutter"
task :release => :build do
  system "git tag -a v#{I18S::VERSION} -m 'Tagging #{I18S::VERSION}'"
  system "git push --tags"
  system "gem push pkg/i18n_sync-#{I18S::VERSION}.gem"
end


RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => [:spec]
