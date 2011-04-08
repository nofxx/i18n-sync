require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "i18n_sync"
    gem.summary = %Q{Syncs all locale yml/rb files based on a "master" one.}
    gem.description = %Q{Gem to sync all locale yml/rb files based on a "master" one.}
    gem.email = "x@nofxx.com"
    gem.homepage = "http://github.com/nofxx/i18n_sync"
    gem.authors = ["Marcos Piccinini"]
    gem.add_dependency "ya2yaml"
    gem.add_development_dependency "rspec", ">= 2.5.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


desc "Runs spec suite"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/*_spec.rb'
  spec.rspec_opts = ['--backtrace --colour']
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "i18n_sync #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
