# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{harvestthings}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Krisher"]
  s.date = %q{2009-12-16}
  s.description = %q{harvestthings will sync your clients, projects, and tasks between Things and Harvest, where areas in Things correspond to clients in Harvest}
  s.email = %q{mike@mikekrisher.com}
  s.extra_rdoc_files = [
    "README.mdown",
     "TODO"
  ]
  s.files = [
    ".gitignore",
     "README.mdown",
     "Rakefile",
     "TODO",
     "VERSION.yml",
     "harvestthings.gemspec",
     "lib/harvestthings.rb",
     "lib/harvestthings/application.rb",
     "lib/harvestthings/harvest.rb",
     "lib/harvestthings/sync.rb",
     "lib/harvestthings/things.rb",
     "lib/harvestthings/things/projects.rb",
     "lib/harvestthings/things/tasks.rb",
     "pkg/harvestthings-0.1.0.gem",
     "pkg/harvestthings-1.0.0.gem"
  ]
  s.homepage = %q{http://github.com/mkrisher/HarvestThings}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{sync projects and tasks between Things and Harvest}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.8.1"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.8.1"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.8.1"])
  end
end

