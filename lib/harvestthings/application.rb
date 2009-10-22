# load library files
begin
  require 'harvestthings/harvest.rb'
  require 'harvestthings/things.rb'
rescue LoadError => e
  puts "there was an error loading a dependancy: #{e}"
end

module HarvestThings
  
  class Application
    
    # define Harvest config file path
    CONFIG_PATH = "harvestthings/harvest/config.rb"
    
    def initialize
      
      generate_config unless File.exists?(CONFIG_PATH)
      
      require "harvestthings/harvest/config"
      
      @harvest = Harvest(HarvestConfig::attrs)
      @things = Things.new
      
      sync
    end
    
    def sync
      puts "syncing..."
      things_projects_to_harvest
      puts "finished. ciao!"
    end
    
  private
    
    def things_projects_to_harvest
      @harvest_project_names = []
      @harvest.projects.find(:all).each { |p| @harvest_project_names.push p.name.downcase }
      
      # loop thru things projects
      @things.projects.each do |project|
        name = @things.project_title(project).downcase
        client = @things.project_area(project).downcase
        # check to see if the client exists in harvest and grab the id, 
        id = harvest_client?(client)
        if id == false
          id = add_client_to_harvest(client)
        end
        add_project_to_harvest(name, id) unless harvest_project?(name)
      end
    end
    
    def harvest_project?(proj_name)
      @harvest_project_names.include?(proj_name)
    end
    
    def harvest_client?(area_name)
      clients = @harvest.clients.find(:all)
      client_id = 0
      clients.each do |c|
        if c.name.downcase == area_name.downcase
          client_id = c.id
        end 
      end
      client_id != 0 ? client_id : false
    end
    
    def add_project_to_harvest(proj_name, client)
      puts "adding #{proj_name} to harvest for client #{client}"
      project = @harvest.projects.new
      project.attributes = {:name => proj_name, :active => true,
                               :bill_by => "None", :client_id => client, }
      project.save
    end
    
    def add_client_to_harvest(area_name)
      client = @harvest.clients.new
      client.attributes = {:name => area_name}
      client.save
      return client.id
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