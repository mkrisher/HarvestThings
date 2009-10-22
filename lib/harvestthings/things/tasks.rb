######################################################################
# Things Tasks module object.
#
module Tasks
  # tasks - grab an array of the various task ids from the xml
  #
  # @param [id] - the string of the project's id 
  # @return [Array] - array of the various task ids
  def tasks(id)
    project = @xml.search("object[@id='#{id}']")
    project.search("relationship[@name='children']") do |elem|
      return elem.attributes["idrefs"].to_s.split(" ")
    end
  end
  
  # task_description - grab formatted version of a task's description
  #
  # @param [id] - the tasks id 
  # @return [String] - a formatted string of the task description 
  def task_description(id)
    task = @xml.search("object[@id='#{id}']")
    title = task.search("attribute[@name='title']")
    clean(title.innerHTML.to_s)
  end
  
  # task_complete? - boolean of whether the task is complete
  #
  # @param [id] - the task id 
  # @return [Boolean] - returns true of false 
  def task_complete?(id)
    task = @xml.search("object[@id='#{id}']")
    task.search("attribute[@name='datecompleted']").any?
  end
  
private

  # clean - clean a title string with specific rules  
  #
  # @param [str] - the string to clean and return 
  # @return [String] - the cleaned string 
  def clean(str)
    # remove any underscores
    $temp = str.gsub("_", " ")
    $temp = $temp.gsub(/^[a-z]|\s+[a-z]/) { |a| a.upcase }
  end
end