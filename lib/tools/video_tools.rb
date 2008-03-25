# Name: VideoTools
# Author: Kai Kousa
# Description: Contains the low-level-methods for videoediting. 
# Contributions: fitVideoToScreen-method was taken from Fooga's original sources.

require 'config'

class VideoTools
  def initialize
    @settings = Config.instance.settings
  end
  
  def trimVideo(movie, visual)
    #cmd = settings['video_trim']
    #cmd.sub!('<source>', visual.file)
    #cmd.sub!('<width>', movie.width)
    #cmd.sub!
  end
  
  def createVideoFromImage(movie, visual)
    #Create a video file from an image using the properties of Visual-object.
    #Update type and file of the Visual
  end
  
  def createVideoFromScratch(movie, visual, text)
    #Render an image and attach a centered text to it.
    #then create a video file from it
    #
    #createVideoFromImage(movie, visual)
  end
  
  def combineVideo(sequence)
    
  end
  
  def multiplex(videoFile, audioFile, format)
    
  end
  
  def fitVideoToScreen ( original_w, original_h, target_w, target_h )

    ratio = original_w.to_f / original_h.to_f

    if ratio > 1.34

      inner_height = ( target_w.to_f / ratio ).round

      padding = target_h.to_f - inner_height

      padding_top = ( padding / 2 ).round
      padding_bottom = padding_top

      unless padding_top % 2 == 0
        padding_top = padding_top + 1
        padding_bottom = padding_bottom - 1
      end

      if not ( padding_top + padding_bottom + inner_height.round ) == target_h

        height_difference = target_h.to_f - ( padding_top.round + padding_bottom.round + inner_height.round )

        if height_difference > 0
          inner_height = inner_height.round - height_difference
        else
          inner_height = inner_height.round + height_difference
        end

      end

    else 
      padding_top = 0
      padding_bottom = 0
      inner_width = target_w.to_i
      inner_height = target_h.to_i
    end

    output = { "inner_width" => target_w.to_s, "inner_height" => inner_height.round.to_s, "padding_top" => padding_top.round.to_s, "padding_bottom" => padding_bottom.round.to_s }

  end
  
end
