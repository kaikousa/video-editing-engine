# Name: TestVolumePoint
# Author: Kai Kousa
# Description: Test cases for VolumePoint-class
require "model/volume_point"
require 'test/unit'
 

class TestVolumePoint < Test::Unit::TestCase
  
  def testInitialize
    point = VolumePoint.new(100, "00:00:00:00")
    assert_equal(0, point.point.milliseconds)
  end
  
end
