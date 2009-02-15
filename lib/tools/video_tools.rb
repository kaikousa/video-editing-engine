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
    @generated_videos = 0
  end
  
  def trim_video(movie, visual)
    inspector = VideoInspector.new
    inspector.inspect(visual)
    
    filename = (File.basename(visual.file)).split(".")[0] + "_trimmed.avi" #Liian clever-clever => refaktoroi
    trimmed_file = movie.project.trimmed + "/" + filename
    resolutions = fit_video_to_screen(visual.width, visual.height, movie.width, movie.height)
    cmd = @settings['video_trim'].dup
    
    cmd.sub!('<source>', visual.file)
    cmd.sub!('<width>', resolutions['inner_width'])
    cmd.sub!('<height>', resolutions['inner_height'])
    cmd.sub!('<padding_top>', resolutions['padding_top'])
    cmd.sub!('<padding_bottom>', resolutions['padding_bottom'])
    cmd.sub!('<in>', visual.start_point)
    cmd.sub!('<length>', visual.length_in_seconds.to_s)
    cmd.sub!('<target>', trimmed_file)
    #puts cmd
    puts "Prosessing: #{filename}"
    system(cmd)
    visual.file = trimmed_file
  end
  
  def create_video_from_image(movie, visual)
    #Create a video file from an image using the properties of Visual-object.
    #Update type and file of the Visual
    
    source_image = Magick::Image.read(visual.file).first
    resized = source_image.change_geometry(movie.resolution){|cols, rows, img|
      img.resize!(cols, rows, filter=Magick::LanczosFilter)
    }
    black_bg = Magick::Image.new(movie.width.to_i, movie.height.to_i){
      self.background_color = "black"
    }
    x_offset = 0
    y_offset = 0
    video_ratio = movie.width.to_i / movie.height.to_i.to_f
    still_ratio = resized.columns / resized.rows.to_f
    if(still_ratio < video_ratio)
      x_offset = ((movie.width.to_i - resized.columns) / 2).round
    else
      y_offset = ((movie.height.to_i - resized.rows) / 2).round
    end
    
    filename = movie.project.trimmed + "/" + (File.basename(visual.file)).split(".")[0] + "_trimmed."
    
    gc = Magick::Draw.new
    gc.composite(x_offset, y_offset, 0, 0, resized)
    gc.draw(black_bg)
    black_bg.write(filename + "jpg"){
      self.quality = 100
    }
    cmd = @settings['still_video'].dup
    length = visual.end_point - visual.start_point
    cmd.sub!('<frames>', length.to_frames(25).to_s)
    cmd.sub!('<source>', filename + "jpg")
    cmd.sub!('<resolution>', movie.resolution)
    cmd.sub!('<target>', filename + "avi")
    
    visual.file = filename + "avi"
    visual.type = "video"
    system(cmd)
  end
  
  #Creates a black screen for that is as long as the given visual
  def create_black_video(movie, visual)
    #Render an image and create a video file from it
    @generated_videos += 1
    filename = movie.project.trimmed + "/generated-#{@generated_videos}.avi"
    cmd = @settings['still_video'].dup
    length = visual.end_point - visual.start_point
    cmd.sub!('<frames>', length.to_frames(25).to_s)
    cmd.sub!('<source>', VREConfig.instance.vre_root + "resources/black_box.png")
    cmd.sub!('<resolution>', movie.resolution)
    cmd.sub!('<target>', filename)
    system(cmd)
    visual.file = filename
    visual.type = "video"
    visual.mute = true
  end
  
  #Combine clips in a movie
  def combine_video(movie)
    trimmed_visuals = ""
    contents = movie.visual_sequence.visuals
    contents.each{|visual|
      trimmed_visuals += " #{visual.file}"
    }
    video_file = movie.project.final + "/videotrack.avi"
    cmd = @settings['video_combine'].dup
    cmd.sub!('<source>', trimmed_visuals)
    cmd.sub!('<target>', video_file)
    puts "Combining videos"
    #puts cmd
    system(cmd)
    return video_file
  end
  
  #Combine video- and audiotracks to one videofile
  def multiplex(movie, video_file, audio_file)
    codecs = ['xvid', 'mpeg2', 'mp4']
    codec = 'xvid'
    if codecs.include?(movie.format)
      codec = movie.format
    end
    
    if(codec == "xvid")
      multiplexer = XvidMultiplexer.new
      multiplexer.multiplex(movie, video_file, audio_file)
    elsif(codec == "mpeg2")
      multiplexer = Mpeg2Multiplexer.new
      multiplexer.multiplex(movie, video_file, audio_file)
    elsif(codec == "mp4")
      multiplexer = Mp4Multiplexer.new
      multiplexer.multiplex(movie, video_file, audio_file)
    end
    
  end
  
  def fit_video_to_screen (original_w, original_h, target_w, target_h)

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
