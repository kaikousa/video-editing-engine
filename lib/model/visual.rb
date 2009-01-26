#Name: Movie
#Author: Kai Kousa
#Description: Encapsulates data related to a visual element in the movie
#(video, images)

class Visual
  
  attr_reader(:type, :file, :start_point, :end_point, :place, :mute, :volume_points, :effects)
  attr_reader(:fps, :width, :height)
  
  def initialize(type, file, start_point, end_point, place, mute, volume_points, effects)
    @type = type
    @file = file
    @start_point = TimeCode.new(start_point)
    @end_point = TimeCode.new(end_point)
    @place = TimeCode.new(place)
    @mute = mute
    
    @volume_points = volume_points
    unless @volume_points == nil
        @volume_points = []
    end    
    unless @volume_points.length == 0
        @volume_points << VolumePoint.new(100, 0)
        @volume_points << VolumePoint.new(100, self.length)
    end        
     
    @effects = effects
    @fps = 0
    @height = 0
    @width = 0
  end
  
  def type=(type)
    @type = type
  end
  
  def file=(file)
    @file = file
  end
  
  def start_point=(start_point)
    @start_point = start_point
  end
  
  def end_point=(end_point)
    @end_point = end_point
  end
  
  def place=(place)
    @place = place
  end
  
  def mute=(mute)
    @mute = mute
  end
  
  def volume_points=(volume_points)
    @volume_points = volume_points
  end
  
  def effects=(effects)
    @effects = effects
  end  
  
  def fps=(fps)
    @fps = fps
  end
  
  def height=(height)
    @height = height
  end
  
  def width=(width)
    @width = width
  end
  
  #Returns the length of the clip (end_point - start_point)
  def length()
    return (@end_point.milliseconds - @start_point.milliseconds)
  end
  
  def length_in_seconds()
    return (@end_point.seconds - @start_point.seconds)
  end
  
  def timeline_end_point()
    return (@place + TimeCode.new(length()))
  end
  
  #Returns false if the visual has no audiotrack, is an image,
  #the track is muted or the volume is 0.
  #ToDo: Check the audio from the real file(preferably with the aid of audiotools)
  #ToDo: Check the levels of volume_points
  def audio?
    #or @volume == 0
    if @mute or @type == "image"
      #puts "no audio"
      return false
    else
      #puts "has audio"
      return true
    end
  end

  #point = point on the timeline (in milliseconds)
  def in_range?(point)
    #point = TimeCode.new(point)
    if point < @place.milliseconds
      return false
    elsif  point > (@place.milliseconds + @end_point.milliseconds)
      return false
    else      
      return true
    end
  end
  
  def to_str()
    "Type: #{@type} File: #{@file} start_point: #{@start_point} end_point: #{@end_point} Mute: #{@mute} Volume: #{@volume_points}"
  end
  
end
