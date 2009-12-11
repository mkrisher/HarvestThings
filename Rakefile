require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "harvestthingstest"
    gemspec.summary = "sync projects and tasks between Things and Harvest"
    gemspec.description = "harvestthings will sync your clients, projects, and tasks between Things and Harvest, where areas in Things correspond to clients in Harvest"
    gemspec.email = "barry@bjhess.com"
    gemspec.homepage = "http://github.com/bjhess/HarvestThings"
    gemspec.authors = ["Barry Hess"]
    gemspec.add_dependency('hpricot', '>= 0.8.1')
    gemspec.add_dependency('jcode')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Jeweler::GemcutterTasks.new