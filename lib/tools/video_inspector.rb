# Name: VideoInspector
# Author: Kai Kousa with copy-pasted code from Matti Venäläinen and Markku Lempinen's
# original Fooga sources.
# Description: 

require 'config'

class VideoInspector
  def initialize
    
  end
  
  def inspect(visual)
    fps = 0.0

    cmd = Config.instance.settings['ffmpeg_get_info']
    cmd.sub!('<source_file>', visual.file)

    IO.popen(cmd) do |pipe|
      pipe.each("\n") do |line|
        if line =~ /(\d+).(\d+) fps/
          visual.fps=(($1 + '.' + $2).to_f) if fps == 0.0
        end

        if line =~ /(\d+)x(\d+),/
          visual.width=($1.to_i)
          visual.height=($2.to_i)
        end

        if line.include?('Audio:')
          visual.mute=(false)
        else
          visual.mute=(true)
        end
      end
    end
    
  end
  
end
