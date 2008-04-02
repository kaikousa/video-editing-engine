# Name: VideoTools
# Author: Kai Kousa
# Description: Contains the low-level-methods for videoediting. 
# Contributions: fitVideoToScreen-method and most of the method-implementations
# were taken from Fooga's original sources.

require 'config'
require 'tools/video_inspector'
require 'multiplexers/xvid_multiplexer'
require 'multiplexers/mpeg2_multiplexer'
require 'multiplexers/mp4_multiplexer'

class VideoTools
  def initialize
    @settings = Config.instance.settings
    @generatedVideos = 0
  end
  
  def trimVideo(movie, visual)
    inspector = VideoInspector.new
    inspector.inspect(visual)
    
    filename = (File.basename(visual.file)).split(".")[0] + "_trimmed.avi" #Liian clever-clever => refaktoroi
    trimmedFile = movie.project.trimmed + "/" + filename
    resolutions = fitVideoToScreen(visual.width, visual.height, movie.width, movie.height)
    cmd = @settings['video_trim'].dup
    
    cmd.sub!('<source>', visual.file)
    cmd.sub!('<width>', resolutions['inner_width'])
    cmd.sub!('<height>', resolutions['inner_height'])
    cmd.sub!('<padding_top>', resolutions['padding_top'])
    cmd.sub!('<padding_bottom>', resolutions['padding_bottom'])
    cmd.sub!('<in>', visual.startPoint)
    cmd.sub!('<length>', visual.lengthInSeconds.to_s)
    cmd.sub!('<target>', trimmedFile)
    #puts cmd
    puts "Prosessing: #{filename}"
    system(cmd)
    visual.file = trimmedFile
  end
  
  def createVideoFromImage(movie, visual)
    #Create a video file from an image using the properties of Visual-object.
    #Update type and file of the Visual
  end
  
  def createBlackVideo(movie, visual)
    #Render an image and attach a centered text to it.
    #then create a video file from it
    @generatedVideos += 1
    filename = movie.project.trimmed + "/generated-#{@generatedVideos}.avi"
    cmd = @settings['still_video'].dup
    length = visual.endPoint - visual.startPoint
    cmd.sub!('<frames>', length.toFrames(25).to_s)
    cmd.sub!('<source>', Config.instance.vreRoot + "resources/black_box.png")
    cmd.sub!('<resolution>', movie.resolution)
    cmd.sub!('<target>', filename)
    system(cmd)
    visual.file = filename
    visual.type = "video"
    visual.mute = true
  end
  
  def combineVideo(movie)
    trimmedVisuals = ""
    contents = movie.visualSequence.visuals
    contents.each{|visual|
      trimmedVisuals += " #{visual.file}"
    }
    videoFile = movie.project.final + "/videotrack.avi"
    cmd = @settings['video_combine'].dup
    cmd.sub!('<source>', trimmedVisuals)
    cmd.sub!('<target>', videoFile)
    puts "Combining videos"
    system(cmd)
    return videoFile
  end
  
  def multiplex(movie, videoFile, audioFile)
    codecs = ['xvid', 'mpeg2', 'mp4']
    codec = 'xvid'
    if codecs.include?(movie.format)
      codec = movie.format
    end
    
    if(codec == "xvid")
      multiplexer = XvidMultiplexer.new
      multiplexer.multiplex(movie, videoFile, audioFile)
    elsif(codec == "mpeg2")
      multiplexer = Mpeg2Multiplexer.new
      multiplexer.multiplex(movie, videoFile, audioFile)
    elsif(codec == "mp4")
      multiplexer = Mp4Multiplexer.new
      multiplexer.multiplex(movie, videoFile, audioFile)
    end
    
  end
  
  def fitVideoToScreen (original_w, original_h, target_w, target_h)

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
