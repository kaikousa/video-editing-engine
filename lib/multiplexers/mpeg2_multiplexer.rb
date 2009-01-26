# Name: Mpeg2Multiplexer
# Author: Kai Kousa
# Description: Multiplexes final audio and video to a Mpeg2 encoded video
# Contributions: Method implementations have been copied and 
# refactored from work by Matti Venäläinen and Markku Lempinen.
 
require 'vre_config'

class Mpeg2Multiplexer
  def initialize
    @settings = VREConfig.instance.settings
  end
  
  def multiplex(movie, video_file, audio_file)
    cmd = @settings['final_mux'].dup
    cmd.sub!('<source_video>', video_file)
    cmd.sub!('<source_audio>', audio_file)
    
    has_audio = File.exist?(audio_file)
    final_file = movie.project.final + "/#{movie.project.name}.mpg"
    
    cmd.sub!('<video_options>', '-vcodec mpeg2video -b 6000k -aspect 4:3 -maxrate 6000k -minrate 6000k -bufsize 4000k -g 15 -intra -ilme mpeg2video')
    cmd.sub!('<target>', final_file)
    cmd.sub!('<audio_options>', '-map 0:0 -map 1:0 -acodec mp2 -ab 224k -ac 2 -ar 48000k') if has_audio
    cmd.sub!('<audio_options>', '-an') unless has_audio
    
    system(cmd)    
  end
  
end
