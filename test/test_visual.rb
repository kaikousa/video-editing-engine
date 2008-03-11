require '../lib/model/visual'
require 'test/unit'
 
class TestVisual < Test::Unit::TestCase
  def testAudioMute
    visual = Visual.new(1, "video", "", 0, 0, 1, true, 100)
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
