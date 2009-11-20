module Sync
  # define_harvest_tasks - loads all of the existing tasks from Harvest  
  #
  # @return [Array] - array of tasks
  def define_harvest_tasks
    @harvest_task_names = []
    @harvest.tasks.find(:all).each { |t| @harvest_task_names.push(@harvest.tasks.find(t.id).name.downcase) }
  end

  # define_harvest_projects - loads all of the existing projects from Harvest  
  #
  # @return [Array] - array of projects
  def define_harvest_projects
    @harvest_projects = @harvest.projects.find(:all)
    @harvest_project_names = []
    @harvest_projects.each { |p| @harvest_project_names.push p.name.downcase }
  end

  # define_harvest_clients - loads all of the existing clients from Harvest  
  #
  # @return [Array] - array of clients
  def define_harvest_clients
    @harvest_clients = @harvest.clients.find(:all)
  end

  # things_projects_to_harvest - detemines which Things projects get sent to Harvest  
  #
  # @return [Array] - array of projects
  def things_projects_to_harvest
    define_harvest_projects
    define_harvest_tasks
    define_harvest_clients
  
    @things.projects.each do |project|
      name = @things.project_title(project).downcase
      client = @things.project_area(project).downcase
      client_id = harvest_client?(client) ? harvest_client?(client) : add_client_to_harvest(client)
      add_project_to_harvest(name, client_id) unless harvest_project?(name)
      things_tasks_to_harvest(project)
    end
  end

  # things_tasks_to_harvest - determines which Things tasks get sent to Harvest  
  #
  # @return [Array] - array of tasks
  def things_tasks_to_harvest(project)
    @things.tasks(project).each do |task|
      unless @things.task_complete?(task) # complete in Things
        task_desc = @things.task_description(task).downcase
        #puts "#{task_desc} " << harvest_task?(task_desc).to_s
        add_task_to_harvest(project, task_desc) unless harvest_task?(task_desc) # unless already exists in Harvest
      end
    end
  end

  # harvest_project? - checks to see if Things project already exists in Harvest  
  #
  # @param [str] - the project name to check for 
  # @return [Boolean]
  def harvest_project?(proj_name)
    @harvest_project_names.include?(proj_name)
  end

  # harvest_client? - checks to see if Things area already exists as Harvest client  
  #
  # @param [str] - the Things area name 
  # @return [integer] - the matching client id if it exists, otherwise false
  def harvest_client?(area_name)
    client_id = nil
    @harvest_clients.each { |c| client_id = c.id if c.name.downcase == area_name.downcase }
    client_id != nil ? client_id : false
  end

  # harvest_task? - checks to see if a Things task already exists in Harvest  
  #
  # @param [str] - the task description
  # @return [Boolean]
  def harvest_task?(task)
    @harvest_task_names.include?(task)
  end

  # add_project_to_harvest - saves a Things project as a Harvest project  
  #
  # @param [str] - the name of the Things project
  # @param [str] - the area_name the project belongs to in Things
  # @return [Boolean]
  def add_project_to_harvest(proj_name, client)
    project = @harvest.projects.new
    project.attributes = { :name => proj_name, :active => true, :bill_by => "None", :client_id => client, }
    project.save
  end

  # add_client_to_harvest - saves a Things area_name as a Harvest client  
  #
  # @param [str] - the Things area_name 
  # @return [Integer] - the new Harvest client id
  def add_client_to_harvest(area_name)
    client = @harvest.clients.new
    client.attributes = {:name => area_name}
    client.save
    return client.id
  end

  # add_task_to_harvest - saves a Things task as a Harvest task  
  #
  # @param [str] - the Thing project
  # @param [str] - the Things task description
  # @return [String] - the cleaned string
  def add_task_to_harvest(project, task_desc)
    puts "create task #{task_desc} for project: #{harvest_project_id(project)}"
    task = @harvest.tasks.new
    task.attributes = { :name => task_desc, :billable_by_default => true, :is_default => false }
    task.save
    # now create the assignment
    task_assignment = @harvest.task_assignment.new(:id => task.id.to_i)
    task_assignment.create_assignment(harvest_project_id(project))
    #puts task_assignment.to_xml
    puts "#{task_assignment.to_xml}"
    res = task_assignment.save
    puts "task_assignment.save: #{res}"
  end

private

  # harvest_project_id - get the Harvest project id for a Things Project  
  #
  # @param [str] - the Things project id number 
  # @return [Integer] - the Harvest project id
  def harvest_project_id(things_project_id)
    @harvest_projects.each { |p| return p.id if p.name.downcase == @things.project_title(things_project_id).downcase }
  end
  
end