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
    
    # initialize - defines a harvest and things object  
    #
    # @return [Boolean]
    def initialize
      @harvest = Harvest.new
      @things = Things.new
      init_sync if config_checks?
    end
    
    # init_sync - kicks off the syncing  
    #
    # @return [String]
    def init_sync
      puts "starting sync..."
      things_projects_to_harvest
      puts "finished. ciao!"
    end
    
  private
    
    # config_checks? - makes sure the config credentials are correct  
    #
    # @return [Boolean]
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