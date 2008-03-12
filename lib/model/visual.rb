#Name: Movie
#Author: Kai Kousa
#Description: Encapsulates data related to a visual element in the movie
#(video, images)
require "splittable"
include Splittable

class Visual
  
  attr_reader(:type, :file, :startPoint, :endPoint, :place, :mute, :volumePoints, :effects)
  
  def initialize(type, file, startPoint, endPoint, place, mute, volumePoints, effects)
    @type = type
    @file = file
    @startPoint = TimeCode.new(startPoint)
    @endPoint = TimeCode.new(endPoint)
    @place = TimeCode.new(place)
    @mute = mute
    @volumePoints = volumePoints  
    @effects = effects
  end
  
  def startPoint=(startPoint)
    @startPoint = startPoint
  end
  
  def endPoint=(endPoint)
    @endPoint = endPoint
  end
  
  def place=(place)
    @place = place
  end
  
  def mute=(mute)
    @mute = mute
  end
  
  def volumePoints=(volumePoints)
    @volumePoints = volumePoints
  end
  
  def effects=(effects)
    @effects = effects
  end  
  
  #Returns the length of the clip (endpoint - startpoint)
  def length()
    return (@endPoint.milliseconds - @startPoint.milliseconds)
  end
  
  #Returns false if the visual has no audiotrack, is an image,
  #the track is muted or the volume is 0.
  #ToDo: Check the audio from the real file(preferably with the aid of audiotools)
  def audio?
    #or @volume == 0
    unless @mute or @type == "image"
      #puts "has audio"
      return true
    else
      #puts "no audio"
      return false
    end
  end
  
  def effects=(effects)
    @effects = effects
  end
  


  #point = point on the timeline (in milliseconds)
  def inRange?(point)
    #point = TimeCode.new(point)
    if point < @place.milliseconds
      return false
    elsif  point > (@place.milliseconds + @endPoint.milliseconds)
      return false
    else      
      return true
    end
  end
  
  def to_str()
    "Type: #{@type} File: #{@file} StartPoint: #{@startPoint} EndPoint: #{@endPoint} Mute: #{@mute} Volume: #{@volumePoints}"
  end
  
end
