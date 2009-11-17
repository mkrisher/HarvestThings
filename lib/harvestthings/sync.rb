def define_harvest_tasks
  @harvest_task_names = []
  @harvest.tasks.find(:all).each { |t| @harvest_task_names.push(@harvest.tasks.find(t.id).name.downcase) }
end

def define_harvest_projects
  @harvest_projects = @harvest.projects.find(:all)
  @harvest_project_names = []
  @harvest_projects.each { |p| @harvest_project_names.push p.name.downcase }
end

def define_harvest_clients
  @harvest_clients = @harvest.clients.find(:all)
end

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

def things_tasks_to_harvest(project)
  #puts "retrieving tasks from Harvest for project #{harvest_project_id(project)}"
  #@project = @harvest.projects.find(harvest_project_id(project))
  
  @things.tasks(project).each do |task|
    unless @things.task_complete?(task) # complete in Things
      task_desc = @things.task_description(task).downcase
      #puts "#{task_desc} " << harvest_task?(task_desc).to_s
      add_task_to_harvest(project, task_desc) unless harvest_task?(task_desc) # unless already exists in Harvest
    end
  end
end


def harvest_project?(proj_name)
  @harvest_project_names.include?(proj_name)
end

def harvest_client?(area_name)
  client_id = nil
  @harvest_clients.each { |c| client_id = c.id if c.name.downcase == area_name.downcase }
  client_id != nil ? client_id : false
end

def harvest_task?(task)
  @harvest_task_names.include?(task)
end


def add_project_to_harvest(proj_name, client)
  project = @harvest.projects.new
  project.attributes = { :name => proj_name, :active => true, :bill_by => "None", :client_id => client, }
  project.save
end

def add_client_to_harvest(area_name)
  client = @harvest.clients.new
  client.attributes = {:name => area_name}
  client.save
  return client.id
end

def add_task_to_harvest(project, task_desc)
  puts "create task #{task_desc} for project: #{harvest_project_id(project)}"
  task = @harvest.tasks.new
  task.attributes = { :name => task_desc, :billable_by_default => true, :is_default => false }
  task.save
  # now create the assignment
  task_assignment = @harvest.task_assignment.new(:id => task.id)
  task_assignment.create_assignment(harvest_project_id(project))
  res = task_assignment.save
  puts "task_assignment.save: #{res}"
end



def harvest_project_id(things_project_id)
  @harvest_projects.each { |p| return p.id if p.name.downcase == @things.project_title(things_project_id).downcase }
end
