#Name: VolumePoint
#Author: Kai Kousa
#Description: A volume point encapsulates the volume of a clip in time
 require "tools/time_code"

class VolumePoint
  
  attr_reader(:volume, :point)
  
  def initialize(volume, point)
    @volume = volume
    @point = TimeCode.new(point)
  end
end
