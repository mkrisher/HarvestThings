require 'harvestthings/things/projects'
require 'harvestthings/things/tasks'

class Things
  # include the projects mixin
  include Projects
  
  # include the tasks mixin
  include Tasks
  
  # Hpricot doc of Things xml file
  attr_reader :xml
  
  # Define default Things database file path and file name
  DATABASE_PATH = "Library/Application\ Support/Cultured\ Code/Things"
  DATABASE_FILE = "Database.xml"
  
  # initialize - change to the default Things directory and load the xml
  #
  # @return [Boolean]
  def initialize
    current_pwd = Dir.pwd 
    Dir.chdir() # changes to HOME environment variable
    Dir.chdir(DATABASE_PATH)
    if File.exists?(DATABASE_FILE)
      load_database
      methods
    else
      raise SystemError, "can't find the default Things database file"
    end
    Dir.chdir(current_pwd)
  end

  # load_database - loads the databse file into the xml property
  #
  # @return [Hpricot] 
  def load_database
    @xml = Hpricot.XML(open(DATABASE_FILE))
  end  
end