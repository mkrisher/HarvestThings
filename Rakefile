require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "harvestthings"
    gemspec.summary = "sync projects and tasks between Things and Harvest"
    gemspec.description = "harvestthings will sync your clients, projects, and tasks between Things and Harvest, where areas in Things correspond to clients in Harvest"
    gemspec.email = "mike@mikekrisher.com"
    gemspec.homepage = "http://github.com/mkrisher/HarvestThings"
    gemspec.authors = ["Michael Krisher"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Jeweler::GemcutterTasks.new