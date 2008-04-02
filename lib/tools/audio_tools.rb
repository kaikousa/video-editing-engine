# Name: AudioTools
# Author: Kai Kousa
# Description: Contains low-level-methods for audiohandling and -mixing.
# Contributions: Method implementations have been copied and 
# refactored from work by Matti Venäläinen and Markku Lempinen.
require 'config'

class AudioTools
  def initialize
    @settings = Config.instance.settings
  end
  
  def convertAudio(audio, project)
    #Convert from original format to .wav
    #Update file-property in the audio
    filename = (File.basename(audio.file)).split(".")[0] + "_converted.wav"
    cmd = @settings['audio_extract'].dup
    cmd.sub!('<source>', audio.file)
    cmd.sub!('<target>', project.converted + "/#{filename}")
    system(cmd)  
    audio.file = project.converted + "/#{filename}"
  end
  
  def trimAudio(audio, project)
    filename = project.converted + "/" + (File.basename(audio.file)).split(".")[0] + "_channel.ewf"
    
    ewf = "source = #{audio.file}\n"
    ewf << "offset = #{audio.place.seconds.to_f}\n"
    ewf << "start-position = #{audio.startPoint.seconds.to_f}\n"
    ewf << "length = #{audio.lengthInSeconds.to_f}\n"
    f = File.new(filename, 'w')
    f.write(ewf)
    f.close
    audio.ewfFile=(filename)
  end
  
  def mixAudioSequence(sequence, project)
    audios = sequence.audios
    unless(audios.length == 0)
      ecaCmd = "ecasound -b:256 "
      0.upto(audios.length - 1){|i|
        ecaCmd << " -a:#{i + 1} -i #{audios[i].ewfFile}"
      }
    
      audiotrackFilename = project.final + "/audiotrack.wav"
    
      ecaCmd << " -a:all -o #{audiotrackFilename} 1>/dev/null 2>&1"
      puts ecaCmd
      system(ecaCmd)
    else
      audiotrackFilename = Config.instance.vreRoot + "resources/silencio.wav"
    end
    
    return audiotrackFilename
  end
  
end
