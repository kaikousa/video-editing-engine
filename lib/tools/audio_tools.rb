# Name: AudioTools
# Author: Kai Kousa
# Description: Contains low-level-methods for audiohandling and -mixing.
# Contributions: Method implementations have been copied and 
# refactored from work by Matti Venäläinen and Markku Lempinen.
require 'vre_config'

class AudioTools
  def initialize
    @settings = VREConfig.instance.settings
  end
  
  def convert_audio(audio, project)
    #Convert from original format to .wav
    #Update file-property in the audio
    filename = (File.basename(audio.file)).split(".")[0] + "_converted.wav"
    cmd = @settings['audio_extract'].dup
    cmd.sub!('<source>', audio.file)
    cmd.sub!('<target>', project.converted + "/#{filename}")
    system(cmd)  
    audio.file = project.converted + "/#{filename}"
  end
  
  def trim_audio(audio, project)
    filename = project.converted + "/" + (File.basename(audio.file)).split(".")[0] + "_channel.ewf"
    
    ewf = "source = #{audio.file}\n"
    ewf << "offset = #{audio.place.seconds.to_f}\n"
    ewf << "start-position = #{audio.start_point.seconds.to_f}\n"
    ewf << "length = #{audio.length_in_seconds.to_f}\n"
    f = File.new(filename, 'w')
    f.write(ewf)
    f.close
    audio.ewf_file = filename
  end
  
  def mix_audio_sequence(sequence, project)
    audios = sequence.audios
    unless(audios.length == 0)
      eca_cmd = "ecasound -b:256 "
      0.upto(audios.length - 1){|i|
        eca_cmd << " -a:#{i + 1} -i #{audios[i].ewf_file}"
      }
    
      audiotrack_filename = project.final + "/audiotrack.wav"
    
      eca_cmd << " -a:all -o #{audiotrack_filename} 1>/dev/null 2>&1"
      #puts ecaCmd
      system(eca_cmd)
    else
      audiotrack_filename = VREConfig.instance.vre_root + "resources/silencio.wav"
    end
    
    return audiotrack_filename
  end
  
end
