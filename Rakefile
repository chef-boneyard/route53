#!/usr/bin/env rake
require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'

begin
  require 'emeril/rake'
rescue LoadError
  puts '>>>>> Emeril gem not loaded, omitting tasks' unless ENV['CI']
end
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any']
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

task spec: 'spec:all'
task default: [:style, :spec]

namespace :spec do
  targets = []
  Dir.glob('./test/integration/default/*').each do |dir|
    next unless File.directory?(dir)
    targets << File.basename(dir)
  end

  task all: targets
  task default: :all

  targets.each do |target|
    desc "Run serverspec tests to #{target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV['TARGET_HOST'] = target
      t.pattern = "test/integration/default/#{target}/*_spec.rb"
    end
  end
end
