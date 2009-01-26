# Name: Project
# Author: Kai Kousa
# Description: Encapsulates data that is related to project management.

class Project
    
    attr_reader :root, :converted, :final, :originals, :name, :trimmed
    
    def initialize(project_name)
      #Convert the project's name more file system friendly
      project_name = project_name.gsub(" ", "_")#Remove whitespaces
      project_name = project_name.gsub(",", "")#Remove commas
      @name = project_name
    end
    
    def set_project_folders(project_root)
      @root = project_root
      @converted = project_root + "/converted"
      @final = project_root + "/final"
      @originals = project_root + "/originals"
      @trimmed = project_root + "/trimmed"
    end
end