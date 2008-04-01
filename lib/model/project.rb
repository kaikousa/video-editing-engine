# Name: Project
# Author: Kai Kousa
# Description: Encapsulates data that is related to project management.

class Project
    
    attr_reader :root, :converted, :final, :originals, :name, :trimmed
    
    def initialize(projectName)
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