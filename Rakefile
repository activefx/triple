# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

require "triple/version"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Load development console"
task :console do
  require 'irb'
  require 'irb/completion'
  require 'triple'
  Dir["#{File.dirname(__FILE__)}/examples/**/*.rb"].each { |f| load(f) }
  ARGV.clear
  IRB.start
end
