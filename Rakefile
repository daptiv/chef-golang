#!/usr/bin/env rake

require 'foodcritic'
require 'rspec/core/rake_task'
require 'tailor/rake_task'

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end

task :default => [:version, :tailor, :foodcritic, :spec]

task :version do
  IO.write('version.txt', (ENV['BUILD_NUMBER'] ? "0.0.#{ENV['BUILD_NUMBER']}" : '0.0.1'))
end

FoodCritic::Rake::LintTask.new

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = ['--color', '-f documentation', '-tunit']
end

Tailor::RakeTask.new