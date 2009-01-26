# Name: XvidMultiplexer
# Author: Kai Kousa
# Description: Multiplexes final audio and video to a Xvid encoded video
# Contributions: Method implementations have been copied and 
# refactored from work by Matti Venäläinen and Markku Lempinen.

require 'vre_config'

class XvidMultiplexer
  def initialize
    @settings = VREConfig.instance.settings
    
    @new_ffmpeg = false
    cmd = "ffmpeg -version 2>&1"
    IO.popen(cmd) do |pipe|
      pipe.each("\n") do |line|
        if line.include?('libmp3lame')
          @new_ffmpeg = true
        end
      end
    end
  end
  
  def multiplex(movie, video_file, audio_file)
    has_audio = File.exist?(audio_file)
    
    cmd = @settings['final_mux'].dup
    cmd.sub!('<source_video>', video_file)
    cmd.sub!('<source_audio>', audio_file)
    
    vcodec = 'xvid'
    vcodec = 'libxvid' if @new_ffmpeg
    acodec = 'mp3'
    acodec = 'libmp3lame' if @new_ffmpeg

    final_file = movie.project.final + "/#{movie.project.name}.avi"
    
    cmd.sub!('<video_options>', "-vcodec #{vcodec} -b 1600 -qscale 5")
    cmd.sub!('<target>', final_file)
    cmd.sub!('<audio_options>', "-map 0:0 -map 1:0 -acodec #{acodec} -ac 2 -ab 128 -ar 44100") if has_audio
    
    cmd.sub!('<audio_options>', '-an') unless has_audio
    #puts "ready for multiplexing: #{cmd}"
    system(cmd)
  end
  
end
