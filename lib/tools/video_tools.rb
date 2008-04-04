# Name: VideoTools
# Author: Kai Kousa
# Description: Contains the low-level-methods for videoediting. 
# Contributions: fitVideoToScreen-method and most of the method-implementations
# were taken from Fooga's original sources.

require 'vre_config'
require 'tools/video_inspector'
require 'multiplexers/xvid_multiplexer'
require 'multiplexers/mpeg2_multiplexer'
require 'multiplexers/mp4_multiplexer'
require 'rubygems'
require 'RMagick'

class VideoTools
  def initialize
    @settings = VREConfig.instance.settings
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
    
    sourceImage = Magick::Image.read(visual.file).first
    resized = sourceImage.change_geometry(movie.resolution){|cols, rows, img|
      img.resize!(cols, rows, filter=Magick::LanczosFilter)
    }
    blackBg = Magick::Image.new(movie.width.to_i, movie.height.to_i){
      self.background_color = "black"
    }
    xOffset = 0
    yOffset = 0
    videoRatio = movie.width.to_i / movie.height.to_i.to_f
    stillRatio = resized.columns / resized.rows.to_f
    if(stillRatio < videoRatio)
      xOffset = ((movie.width.to_i - resized.columns) / 2).round
    else
      yOffset = ((movie.height.to_i - resized.rows) / 2).round
    end
    
    filename = movie.project.trimmed + "/" + (File.basename(visual.file)).split(".")[0] + "_trimmed."
    
    gc = Magick::Draw.new
    gc.composite(xOffset, yOffset, 0, 0, resized)
    gc.draw(blackBg)
    blackBg.write(filename + "jpg"){
      self.quality = 100
    }
    cmd = @settings['still_video'].dup
    length = visual.endPoint - visual.startPoint
    cmd.sub!('<frames>', length.toFrames(25).to_s)
    cmd.sub!('<source>', filename + "jpg")
    cmd.sub!('<resolution>', movie.resolution)
    cmd.sub!('<target>', filename + "avi")
    
    visual.file = filename + "avi"
    visual.type = "video"
    system(cmd)
  end
  
  def createBlackVideo(movie, visual)
    #Render an image and attach a centered text to it.
    #then create a video file from it
    @generatedVideos += 1
    filename = movie.project.trimmed + "/generated-#{@generatedVideos}.avi"
    cmd = @settings['still_video'].dup
    length = visual.endPoint - visual.startPoint
    cmd.sub!('<frames>', length.toFrames(25).to_s)
    cmd.sub!('<source>', VREConfig.instance.vreRoot + "resources/black_box.png")
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
