# Name: Folder manager
# Author: Kai Kousa
# Description: Manages the temporary folders (create, delete...)

require 'vre_config'

class FolderManager
  def initialize
    
  end
  
  def create_project_layout(project)
      workspace = VREConfig.instance.vre_root + VREConfig.instance.settings['workspace']
      time = Time.now.strftime("%H%M%S%d%m%Y") #hour minute second day month year

      project_folder = workspace + "/#{project.name}-#{time.to_s}"
      #projectFolder = workspace + "/" + project.name
      project.set_project_folders(project_folder)
      create_directory(project.root)
      create_directory(project.originals)
      create_directory(project.converted)
      create_directory(project.final)
      create_directory(project.trimmed)
  end
  
  def clean_project_folder(project)
      remove_directory(project.converted)
      remove_directory(project.originals)
      remove_directory(project.trimmed)
  end
  
  def delete_project_folder(project)
      remove_directory(project.converted)
      remove_directory(project.originals)
      remove_directory(project.trimmed)
      remove_directory(project.final)
      remove_directory(project.root)
  end
  
  #Destroys the files in a directory
  def clear_directory(dir)
    puts dir
      if(File.exists?(dir))
        Dir.foreach(dir){|entry|
          puts entry
            if(File.file?(entry))
                File.delete(entry)
            end
        }
      end
  end
  private :clear_directory
  
  def create_directory(dir)
      Dir.mkdir(dir) unless File.exists?(dir)
  end
  private :create_directory
  
  #Delete files from the directory and delete it afterwards
  def remove_directory(dir)
      if(File.exists?(dir))
        clear_directory(dir)
        Dir.rmdir(dir)
      end
  end
  private :remove_directory
  
end
