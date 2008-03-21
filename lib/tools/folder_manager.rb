# Name: Folder manager
# Author: Kai Kousa
# Description: Manages the temporary folders (create, delete...)

require 'config'

class FolderManager
  def initialize
    
  end
  
  def createProjectLayout(projectName)
      #time = Time.now.strftime("%H%M%S%d%m%Y") #hour minute second day mont year
      workspace = Config.instance.vreRoot + Config.instance.settings['workspace']
      #projectFolder = workspace + "/#{projectName}-#{time.to_s}"
      projectFolder = workspace + "/" + projectName
      createDirectory(projectFolder)
      createDirectory(projectFolder + "/originals")
      createDirectory(projectFolder + "/converted")
      createDirectory(projectFolder + "/final")
  end
  
  def cleanProjectFolder(projectName)
      workspace = Config.instance.vreRoot + Config.instance.settings['workspace']
      projectFolder = workspace + "/" + projectName
      removeDirectory(projectFolder + "/converted")
      removeDirectory(projectFolder + "/originals")
  end
  
  def deleteProjectFolder(projectName)
      workspace = Config.instance.vreRoot + Config.instance.settings['workspace']
      projectFolder = workspace + "/" + projectName
      removeDirectory(projectFolder + "/converted")
      removeDirectory(projectFolder + "/originals")
      removeDirectory(projectFolder + "/final")
      removeDirectory(projectFolder)
  end
  
  def createDirectory(dir)
      Dir.mkdir(dir) unless File.exists?(dir)
  end
  private :createDirectory
  
  #Delete files from the directory and delete it afterwards
  def removeDirectory(dir)
      if(File.exists?(dir))
        Dir.foreach(dir){|entry|
            if(File.file?(entry))
                File.delete(entry)
            end
        }
        Dir.rmdir(dir)
      end
  end
  private :removeDirectory
  
end
