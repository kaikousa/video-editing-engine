#Name: Audio
#Author: Kai Kousa
#Description: Encapsulates all audio related data
require "model/time_code"

class Audio
  
  attr_reader(:file, :start_point, :end_point, :place, :volume_points, :ewf_file)
  
  def initialize(file, start_point, end_point, place, volume_points)
    @file = file
    @start_point = TimeCode.new(start_point)
    @end_point = TimeCode.new(end_point)
    @place = TimeCode.new(place)
    @volume_points = volume_points
    unless @volume_points == nil
        @volume_points = []
    end
    
    unless @volume_points.length == 0
        @volume_points << VolumePoint.new(100, 0)
        @volume_points << VolumePoint.new(100, self.length)
    end
  end
  
  def file=(file)
    @file = file
  end
  
  def start_point=(point)
    @start_point = point
  end
  
  def end_point=(point)
    @end_point = point
  end
  
  def place=(point)
    @place = point
  end
  
  def volume_points=(points)
    @volume_points = points
  end
  
  def ewf_file=(ewf)
    @ewf_file = ewf
  end
  
  #Returns the length of the clip (end_point - start_point)
  def length()
    return (@end_point.milliseconds - @start_point.milliseconds)
  end
  
  def length_in_seconds()
    return (@end_point.seconds - @start_point.seconds)
  end
  
  def to_str()
    "File: #{@file} start_point: #{@start_point} end_point: #{@end_point} Volume: #{@volume} Place: #{@place}"
  end
  
end
