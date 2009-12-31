module Sync
  
  # things_projects_to_harvest - detemines which Things projects get sent to Harvest  
  #
  # @return [Array] - array of projects
  def things_projects_to_harvest
    define_harvest_projects
    define_harvest_tasks
    define_harvest_clients
    
    @things.projects.each do |project|
      print "."
      name = @things.project_title(project).downcase
      client = @things.project_area(project).downcase
      client_id = harvest_client?(client) ? harvest_client_id(client) : add_client_to_harvest(client)
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
        add_task_to_harvest(@things.project_title(project).downcase, task_desc) unless harvest_task?(task_desc) # unless already exists in Harvest
      end
    end
  end

  # add_project_to_harvest - saves a Things project as a Harvest project  
  #
  # @param [str] - the name of the Things project
  # @param [str] - the Harvest client id
  # @return [Boolean]
  def add_project_to_harvest(proj_name, client)
str = <<EOS
  <project>
     <name>#{proj_name}</name>
     <active type="boolean">true</active>
     <bill-by>none</bill-by>
     <client-id type="integer">#{client}</client-id>
     <code></code>
     <notes></notes>
     <budget type="decimal"></budget>
     <budget-by>none</budget-by>
  </project>
EOS
    response = @harvest.request '/projects', :post, str
    # redefine harvest projects, since we've added to it
    define_harvest_projects
  end

  # add_task_to_harvest - saves a Things task as a Harvest task  
  #
  # @param [str] - the Thing project
  # @param [str] - the Things task description
  # @return [String] - the cleaned string
  def add_task_to_harvest(project_name, task_desc)
str = <<EOS
  <task>
    <billable-by-default type="boolean">true</billable-by-default>
    <default-hourly-rate type="decimal"></default-hourly-rate>
    <is-default type="boolean">false</is-default>
    <name>#{task_desc}</name>
  </task>
EOS
    response = @harvest.request '/tasks', :post, str 
    new_task_location = response['Location']
    new_task_id = new_task_location.gsub(/\/tasks\//, '')
    assign_task_assignment(new_task_id, project_name)
  end

  # assign_task_assignment - assigns a newly created task to a Project in Harvest  
  #
  # @param [Integer] - the new Harvest task ID
  # @return [Integer] - the Harvest project ID
  def assign_task_assignment(new_task_id, project_name)
str = <<EOS
  <task>
    <id type="integer">#{new_task_id}</id>
  </task>
EOS
    response = @harvest.request "/projects/#{harvest_project_id(project_name)}/task_assignments", :post, str
  end

  # add_client_to_harvest - saves a Things area_name as a Harvest client  
  #
  # @param [str] - the Things area_name 
  # @return [Integer] - the new Harvest client id
  def add_client_to_harvest(area_name)
str = <<EOS
  <client>
    <name>#{area_name}</name>
    <details></details>
  </client> 
EOS
    response = @harvest.request '/clients', :post, str
    define_harvest_clients
  end



private

  # define_harvest_tasks - loads all of the existing tasks from Harvest  
  #
  # @return [Array] - array of tasks
  def define_harvest_tasks
    @harvest_tasks = []
    
    response = @harvest.request '/tasks', :get
    doc = Hpricot::XML(response.body)
    (doc/:tasks/:task).each do |task|    
      temp = {}
      ['name', 'id'].each do |el|
        temp[el] = task.at(el).innerHTML.downcase
      end
      @harvest_tasks.push temp
    end
  end

  # define_harvest_projects - loads all of the existing projects from Harvest  
  #
  # @return [Array] - array of projects names
  def define_harvest_projects
    @harvest_projects = []
    
    response = @harvest.request '/projects', :get
    doc = Hpricot::XML(response.body)
    (doc/:projects/:project).each do |project|    
      temp = {}
      ['name', 'id'].each do |el|
        temp[el] = project.at(el).innerHTML.downcase
      end
      @harvest_projects.push temp
    end
  end

  # define_harvest_clients - loads all of the existing clients from Harvest  
  #
  # @return [Array] - array of clients names
  def define_harvest_clients
    @harvest_clients = []
    
    response = @harvest.request '/clients', :get
    doc = Hpricot::XML(response.body)
    (doc/:clients/:client).each do |client|    
      temp = {}
      ['name', 'id'].each do |el|
        temp[el] = client.at(el).innerHTML.downcase
      end
      @harvest_clients.push temp
    end
  end
  
  # harvest_project? - checks to see if Things project already exists in Harvest  
  #
  # @param [str] - the project name to check for 
  # @return [Boolean]
  def harvest_project?(proj_name)
    match = false
    @harvest_projects.each do |project|
      if project['name'] == proj_name
        match = true
      end
    end
    return match == false ? false : true
  end

  # harvest_client? - checks to see if Things area already exists as Harvest client  
  #
  # @param [str] - the Things area name 
  # @return [integer] - the matching client id if it exists, otherwise false
  def harvest_client?(area_name)
    match = false
    @harvest_clients.each do |client|
      if client['name'] == area_name
        match = true
      end
    end
    return match == false ? false : true
  end

  # harvest_task? - checks to see if a Things task already exists in Harvest  
  #
  # @param [str] - the task description
  # @return [Boolean]
  def harvest_task?(task_name)
    match = false
    @harvest_tasks.each do |task|
      if task['name'] == task_name
        match = true
      end
    end
    return match == false ? false : true
  end
  
  # harvest_client_id - get the Harvest client id for a Things area name  
  #
  # @param [str] - the Things area name 
  # @return [Integer] - the Harvest client id
  def harvest_client_id(area_name)
    @harvest_clients.each do |client|
      return client['id'] if client['name'] == area_name
    end
  end
  
  # harvest_project_id - get the Harvest project id for a Things project  
  #
  # @param [str] - the Things project id number 
  # @return [Integer] - the Harvest project id
  def harvest_project_id(proj_name)
    @harvest_projects.each do |project|
      return project['id'] if project['name'].downcase.to_s == proj_name.to_s
    end
  end
  
end