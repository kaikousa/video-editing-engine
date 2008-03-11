#Name: Audio
#Author: Kai Kousa
#Description: Encapsulates all audio related data
require "tools/time_code"

class Audio
  
  attr_reader(:file, :startPoint, :endPoint, :offset, :volumePoints)
  
  def initialize(file, startPoint, endPoint, offset, volumePoints)
    @file = file
    @startPoint = TimeCode.new(startPoint)
    @endPoint = TimeCode.new(endPoint)
    @offset = TimeCode.new(offset   )
    @volumePoints = volumePoints
  end
  
  def to_str()
    "File: #{@file} StartPoint: #{@startPoint} EndPoint: #{@endPoint} Volume: #{@volume} Offset: #{@offset}"
  end
  
end
