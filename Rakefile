# encoding: utf-8

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :development)
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "ruby_apk"
  gem.homepage = "https://github.com/SecureBrain/ruby_apk/"
  gem.license = "MIT"
  gem.summary = %Q{static analysis tool for android apk}
  gem.description = %Q{static analysis tool for android apk}
  gem.email = "info@securebrain.co.jp"
  gem.authors = ["SecureBrain"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

task :console do
  exec "irb -r ruby_apk -I ./lib"
end

require 'yard'
require 'yard/rake/yardoc_task'
YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
  t.options = []
  t.options << '--debug' << '--verbose' if $trace
end
