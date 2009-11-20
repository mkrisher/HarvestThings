module Harvest
  module Resources
    class Task < Harvest::HarvestResource
      include Harvest::Plugins::Toggleable
      
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
        self.site = self.site + "/projects/#{self.project_id}"
      end
              
    end
  end
end