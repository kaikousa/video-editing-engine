# Name: AudioTools
# Author: Kai Kousa
# Description: Contains low-level-methods for audiohandling and -mixing.
require 'config'

class AudioTools
  def initialize
    @settings = Config.instance.settings
  end
  
  def convertAudio(audio, project)
    #Convert from original format to .wav
    #Update file-property in the audio
    #extension = File.extname(video.file)
    #filename = File.basename(video.file)
    #filename = filename.split('.')[0] + "_converted.wav"
    #cmd = @settings['audio_extract'].dup
    #cmd.sub!('<source>', video.file)
    #cmd.sub!('<target>', project.converted + "/#{filename}")
    #system(cmd)
    #audio.file = project.converted + "/#{filename}"
  end
  
  def trimAudio(audio, project)
    #ecaCmd = 'ecasound -b:256'
  end
  
  def extractAudio(video, project)

  end
  
  def mixAudioSequence(sequence, project)
    
  end
  
  def generateAudioTrack()
    
  end
  
end
