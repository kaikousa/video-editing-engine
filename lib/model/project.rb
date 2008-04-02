# Name: Project
# Author: Kai Kousa
# Description: Encapsulates data that is related to project management.

class Project
    
    attr_reader :root, :converted, :final, :originals, :name, :trimmed
    
    def initialize(projectName)
      #Convert the project's name more file system friendly
      projectName = projectName.gsub(" ", "_")#Remove whitespaces
      projectName = projectName.gsub(",", "")#Remove commas
      @name = projectName
    end
    
    def setProjectFolders(projectRoot)
      @root = projectRoot
      @converted = projectRoot + "/converted"
      @final = projectRoot + "/final"
      @originals = projectRoot + "/originals"
      @trimmed = projectRoot + "/trimmed"
    end
end