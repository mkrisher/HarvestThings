#
# TODO: use the config file
#

begin
  require 'harvestthings/harvest'
  require 'harvestthings/things'
  require 'harvestthings/sync'
rescue LoadError => e
  puts "there was an error loading a dependancy: #{e}"
end

module HarvestThings
  
  class Application
    
    # include sync mixin
    include Sync
    
    def initialize
      @harvest = Harvest.new
      @things = Things.new
      init_sync if config_checks?
    end
    
    def init_sync
      puts "starting sync..."
      things_projects_to_harvest
      puts "finished. ciao!"
    end
    
  private
    
    def config_checks?
      begin
        response = @harvest.request '/clients', :get
      rescue
        exception = true
      end
      return exception == true ? false : true
    end
    
  end
  
end