require 'rake'
require 'rspec/core/rake_task'

begin
  require 'emeril/rake'
rescue LoadError
  puts ">>>>> Emeril gem not loaded, omitting tasks" unless ENV['CI']
end

RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = ["test/unit/**/*_spec.rb"]
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

require 'foodcritic'
FoodCritic::Rake::LintTask.new do |t|
    t.options = { :fail_tags => ['any'] }
end

begin
 require 'kitchen/rake_tasks'
   Kitchen::RakeTasks.new
rescue LoadError
end

task :default => :spec
