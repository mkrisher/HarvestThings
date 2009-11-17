# This class is accessed by an instance of Project.
module Harvest
  module Resources
    class TaskAssignment < Harvest::HarvestResource
      
      self.element_name = "task"
      
      def self.project_id=(id)
        @project_id = id
        set_site
      end
                    
      def self.project_id
        @project_id
      end
      
      def self.task_id=(id)
        @id = id
      end
                    
      def self.task_id
        @id
      end
                    
      def self.set_site
        self.site = self.site + "/projects/#{self.project_id}/task_assignments"
      end
      
      def create_assignment(project_id)
        # Assign a task to a project
        # POST /projects/#{project_id}/task_assignments
        # HTTP Response: 201 Created
        # Location: /projects/#{project_id}/task_assignments/#{new_task_assignment_id}
        TaskAssignment::project_id = project_id
        TaskAssignment::set_site
      end
                  
    end
  end
end