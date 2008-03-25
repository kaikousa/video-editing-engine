# Name: Folder manager
# Author: Kai Kousa
# Description: Manages the temporary folders (create, delete...)

require 'config'

class FolderManager
  def initialize
    
  end
  
  def createProjectLayout(project)
      workspace = Config.instance.vreRoot + Config.instance.settings['workspace']
      time = Time.now.strftime("%H%M%S%d%m%Y") #hour minute second day mont year
      projectFolder = workspace + "/#{project.name.gsub(" ", "_")}-#{time.to_s}"
      #projectFolder = workspace + "/" + project.name
      project.setProjectFolders(projectFolder)
      createDirectory(project.root)
      createDirectory(project.originals)
      createDirectory(project.converted)
      createDirectory(project.final)
  end
  
  def cleanProjectFolder(project)
      removeDirectory(project.converted)
      removeDirectory(project.originals)
  end
  
  def deleteProjectFolder(project)
      removeDirectory(project.converted)
      removeDirectory(project.originals)
      removeDirectory(project.final)
      removeDirectory(project.root)
  end
  
  #Destroys the files in a directory
  def clearDirectory(dir)
      if(File.exists?(dir))
        Dir.foreach(dir){|entry|
            if(File.file?(entry))
                File.delete(entry)
            end
        }
      end
  end
  private :clearDirectory
  
  def createDirectory(dir)
      Dir.mkdir(dir) unless File.exists?(dir)
  end
  private :createDirectory
  
  #Delete files from the directory and delete it afterwards
  def removeDirectory(dir)
      if(File.exists?(dir))
        clearDirectory(dir)
        Dir.rmdir(dir)
      end
  end
  private :removeDirectory
  
end
