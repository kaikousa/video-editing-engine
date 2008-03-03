#Name: Movie
#Author: Kai Kousa
#Description: Encapsulates all audio related data
 

class Audio
  
  attr_reader :file, :volume, :startPoint, :endPoint, :offset 
  
  def initialize(file, volume, startPoint, endPoint, offset)
    @file = file
    @volume = volume
    @startPoint = startPoint
    @endPoint = endPoint
    @offset = offset    
  end
  
  def to_str()
    "File: #{@file} StartPoint: #{@startPoint} EndPoint: #{@endPoint} Volume: #{@volume} Offset: #{@offset}"
  end
  
end
