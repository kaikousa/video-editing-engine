require 'model/visual'
require 'model/volume_point'
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
    #visual = Visual.new("video", "", "00:00:00:00", "00:00:00:00", 1, true, 100)
    visual = getDefaultVisual()
    visual.mute=(true)
    assert_equal(false, visual.audio?)
  end
  
  def testAudioNotMute
    visual = getDefaultVisual() #Visual.new(1, "video", "", 0, 0, 1, false, 100)
    visual.mute=(false)
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
  
  def testTimelineEndPoint
    visual = getDefaultVisual()
    assert_equal("0:0:10:0", visual.timelineEndPoint.timeCodeStr)
  end
end
