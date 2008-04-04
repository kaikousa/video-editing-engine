# Name: XvidMultiplexer
# Author: Kai Kousa
# Description: Multiplexes final audio and video to a Xvid encoded video
# Contributions: Method implementations have been copied and 
# refactored from work by Matti Venäläinen and Markku Lempinen.

require 'vre_config'

class XvidMultiplexer
  def initialize
    @settings = VREConfig.instance.settings
    
    @newFfmpeg = false
    cmd = "ffmpeg -version 2>&1"
    IO.popen(cmd) do |pipe|
      pipe.each("\n") do |line|
        if line.include?('libmp3lame')
          @newFfmpeg = true
        end
      end
    end
  end
  
  def multiplex(movie, videoFile, audioFile)
    hasAudio = File.exist?(audioFile)
    
    cmd = @settings['final_mux'].dup
    cmd.sub!('<source_video>', videoFile)
    cmd.sub!('<source_audio>', audioFile)
    
    vcodec = 'xvid'
    vcodec = 'libxvid' if @newFfmpeg
    acodec = 'mp3'
    acodec = 'libmp3lame' if @newFfmpeg

    finalFile = movie.project.final + "/#{movie.project.name}.avi"
    
    cmd.sub!('<video_options>', "-vcodec #{vcodec} -b 1600 -qscale 5")
    cmd.sub!('<target>', finalFile)
    cmd.sub!('<audio_options>', "-map 0:0 -map 1:0 -acodec #{acodec} -ac 2 -ab 128 -ar 44100") if hasAudio
    
    cmd.sub!('<audio_options>', '-an') unless hasAudio
    puts "ready for multiplexing: #{cmd}"
    system(cmd)
  end
  
end
