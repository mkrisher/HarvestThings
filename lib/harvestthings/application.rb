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
    
    # define Harvest config file path
    CONFIG_PATH = "harvestthings/harvest/config.rb"
    
    def initialize
      generate_config unless File.exists?(CONFIG_PATH)
      load "harvestthings/harvest/config.rb"
      @harvest = Harvest(HarvestConfig::attrs)
      @things = Things.new
      init_sync if config_checks?
    end
    
    def init_sync
      puts "syncing..."
      things_projects_to_harvest
      puts "finished. ciao!"
    end
    
  private
    
    def config_checks?
      begin
        temp = @harvest.projects.find(:all)
      rescue
        puts "Harvest authorization issue, please enter your login information:"
        generate_config
        initialize
      end
      return temp.nil? ? false : true
    end
    
    def generate_config
      # define email
      puts "enter the email you use to log into Harvest:"
      email = gets
      # define password
      puts "enter the password for this Harvest account:"
      password = gets
      # define subdomain
      puts "enter the subdomain for your Harvest account:"
      subdomain = gets

str = <<EOS
class HarvestConfig
  def self.attrs(overwrite = {})
  {
    :email      => "#{email.chomp!}", 
    :password   => "#{password.chomp!}", 
    :sub_domain => "#{subdomain.chomp!}",
    :headers    => { "User-Agent" => "Harvest Rubygem" }
  }.merge(overwrite)
  end
end
EOS
      File.open(CONFIG_PATH, 'w') {|f| f.write(str) }
    end

  end
  
end