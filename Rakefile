require 'rubygems'
require 'rake'
require 'fileutils'

task :default => [:test, :run]

desc "Play BaconBits"
task :run do
  FileUtils.cd('lib') do
    sh "ruby baconbits.rb"
  end
end

desc "Run all tests"
task :test do
  # TODO	
end