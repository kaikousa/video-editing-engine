#Name: Movie
#Author: Kai Kousa
#Description: Encapsulates data related to a visual element in the movie
#(video, images)
require "splittable"
include Splittable

class Visual
  
  attr_reader(:index, :type, :file, :startPoint, :endPoint, :place, :mute, :volume)
  
  def initialize(index, type, file, startPoint, endPoint, place, mute, volume)
    @index = index
    @type = type
    @file = file
    @startPoint = startPoint
    @endPoint = endPoint
    @place = place
    @mute = mute
    @volume = volume    
  end
  
  #Returns false if the visual has no audiotrack, is an image,
  #the track is muted or the volume is 0.
  #ToDo: Check the audio from the real file(preferably with the aid of audiotools)
  def audio?
    unless @mute or @volume == 0 or @type == "image"
      puts "has audio"
      return true
    else
      puts "no audio"
      return false
    end
  end
  
  def inRange?(splitPoint)
    if splitPoint < @startPoint or splitPoint > endPoint
      return false
    else 
      return true
    end
  end
  
  def to_str()
    "Index: #{@index} Type: #{@type} File: #{@file} StartPoint: #{@startPoint} EndPoint: #{@endPoint} Mute: #{@mute} Volume: #{@volume}"
  end
  
end
