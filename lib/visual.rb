#Name: Movie
#Author: Kai Kousa
#Description: Encapsulates data related to a visual element in the movie
#(video, images)
 

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
  #the track is muted of the volume is 0.
  def audio?
    
  end
  
  def to_str()
    "Index: #{@index} Type: #{@type} File: #{@file} StartPoint: #{@startPoint} EndPoint: #{@endPoint} Mute: #{@mute} Volume: #{@volume}"
  end
  
end
