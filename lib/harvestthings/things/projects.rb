module Projects
  # projects - grab an array of the various project ids from the xml
  #
  # @param [id] - the string of the project's id 
  # @return [Hpricot] - an Hpricot XML object
  def projects
    # find all projects from the first OBJECT node
    first_obj = @xml.at('object')
    
    if first_obj.search("relationship[@destination='TODO']").length != 0 
      first_obj.search("relationship[@destination='TODO']") do |elem| # older versions of Things
          return elem.attributes["idrefs"].to_s.split(" ")
        end
      else
        @xml.search("attribute[@name='title']") do |elem| # newer versions of Things
          if elem.html == "Projects"
            elem.parent.search("relationship[@name='focustodos']") do |e|
              return e.attributes["idrefs"].to_s.split(" ")
            end
          end
        end
    end
    
  end
  
  # project - grab the Hpricot element of the project using the id  
  #
  # @param [id] - the string of the project's id 
  # @return [Hpricot] - an Hpricot XML object
  def project(id)
    @xml.search("object[@id='#{id}']")
  end
  
  # project_title - grab the title of the project using the id  
  #
  # @param [id] - the string of the project's attribute id 
  # @return [String] - a cleaned and formatted title string
  def project_title(id)
    project = @xml.search("object[@id='#{id}']")
    title = project.search("attribute[@name='title']")
    clean(title.innerHTML.to_s)
  end
  
  # project_area - grab the area of the project using the id  
  #
  # @param [id] - the string of the project's attribute id 
  # @return [String] - a cleaned and formatted area string
  def project_area(id)
    project = @xml.search("object[@id='#{id}']")
    area = project.search("relationship[@name='parent']")
    area_id = area.attr('idrefs').to_s
    area_id == "" ? "default" : project_title(area_id)
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