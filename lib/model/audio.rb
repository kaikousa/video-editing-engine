#Name: Audio
#Author: Kai Kousa
#Description: Encapsulates all audio related data
require "model/time_code"

class Audio
  
  attr_reader(:file, :startPoint, :endPoint, :place, :volumePoints, :ewfFile)
  
  def initialize(file, startPoint, endPoint, place, volumePoints)
    @file = file
    @startPoint = TimeCode.new(startPoint)
    @endPoint = TimeCode.new(endPoint)
    @place = TimeCode.new(place)
    @volumePoints = volumePoints
    unless @volumePoints == nil
        @volumePoints = []
    end
    
    unless @volumePoints.length == 0
        @volumePoints << VolumePoint.new(100, 0)
        @volumePoints << VolumePoint.new(100, self.length)
    end
  end
  
  def file=(file)
    @file = file
  end
  
  def startPoint=(point)
    @startPoint = point
  end
  
  def endPoint=(point)
    @endPoint = point
  end
  
  def place=(point)
    @place = point
  end
  
  def volumePoints=(points)
    @volumePoints = points
  end
  
  def ewfFile=(ewf)
    @ewfFile = ewf
  end
  
  #Returns the length of the clip (endpoint - startpoint)
  def length()
    return (@endPoint.milliseconds - @startPoint.milliseconds)
  end
  
  def lengthInSeconds()
    return (@endPoint.seconds - @startPoint.seconds)
  end
  
  def to_str()
    "File: #{@file} StartPoint: #{@startPoint} EndPoint: #{@endPoint} Volume: #{@volume} Place: #{@place}"
  end
  
end
