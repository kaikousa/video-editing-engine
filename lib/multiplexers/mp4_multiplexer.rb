# Name: Mp4Multiplexer
# Author: Kai Kousa
# Description: Multiplexes final audio and video to a mp4 encoded video
# Contributions: Method implementations have been copied and 
# refactored from work by Matti Venäläinen and Markku Lempinen.
 
require 'vre_config'

class Mp4Multiplexer
  def initialize
    @settings = VREConfig.instance.settings
  end
  
  def multiplex(movie, video_file, audio_file)
    cmd = @settings['final_mux'].dup
    cmd.sub!('<source_video>', video_file)
    cmd.sub!('<source_audio>', audio_file)
    
    has_audio = File.exist?(audio_file)
    final_file = movie.project.final + "/#{movie.project.name}.mp4"
    
    cmd.sub!('<video_options>', '-vcodec mpeg4 -b 200 -maxrate 200 -minrate 200 -bufsize 512')
    cmd.sub!('<target>', final_file)
    cmd.sub!('<audio_options>', '-map 0:0 -map 1:0 -acodec amr_nb -b 200 -ab 64 -ar 8000 -ac 1') if has_audio
    
    cmd.sub!('<audio_options>', '-an') unless has_audio
    #puts(cmd)
    system(cmd)
  end
  
end
