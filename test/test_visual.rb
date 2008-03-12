require '../lib/model/visual'
require 'test/unit'
 
class TestVisual < Test::Unit::TestCase
  
  def getDefaultVisual
    volumePoints = []
    volumePoints << VolumePoint.new(100, "00:00:00:00")
    volumePoints << VolumePoint.new(100, "00:00:10:00")
    visual = Visual.new("video", "", "00:00:00:00", "00:00:10:00", "00:00:00:00", false, volumePoints, [])
    return visual
  end
  
  def testAudioMute
    visual = Visual.new("video", "", "00:00:00:00", "00:00:00:00", 1, true, 100)
    assert_equal(false, visual.audio?)
  end
  
  def testAudioNotMute
    visual = Visual.new(1, "video", "", 0, 0, 1, false, 100)
    assert_equal(true, visual.audio?)
  end
  
  def testVolumeZero
    visual = Visual.new(1, "video", "", 0, 0, 1, true, 0)
    assert_equal(false, visual.audio?)
  end
  
  def testImageVisual
    visual = Visual.new(1, "image", "", 0, 0, 1, false, 100)
    assert_equal(false, visual.audio?)
  end
end
