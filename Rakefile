require 'rubygems'
require 'rake'
require 'fileutils'
require 'rubygems'
require 'rspec/core/rake_task'

$LOAD_PATH << File.expand_path('./lib')
$LOAD_PATH << File.expand_path('./specs')

desc "Play BaconBits"
task :run do
  sh "ruby lib/baconbits.rb"
end
 
desc 'Default: run specs.'
task :default => [:spec, :run]
 
desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./specs/*_spec.rb" # don't need this, it's default.
  # Put spec opts in a file named .rspec in root
end
 
desc "Generate code coverage"
RSpec::Core::RakeTask.new(:coverage) do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end