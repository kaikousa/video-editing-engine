require 'model/visual'
require 'model/volume_point'
require 'model/time_code'
require 'test/unit'
 
class TestVisual < Test::Unit::TestCase
  
  def get_default_visual
    volume_points = []
    volume_points << VolumePoint.new(100, "00:00:00:00")
    volume_points << VolumePoint.new(100, "00:00:10:00")
    visual = Visual.new("video", "", "00:00:00:00", "00:00:10:00", "00:00:00:00", false, volume_points, [])
    return visual
  end
  
  def test_audio_mute
    #visual = Visual.new("video", "", "00:00:00:00", "00:00:00:00", 1, true, 100)
    visual = get_default_visual()
    visual.mute=(true)
    assert_equal(false, visual.audio?)
  end
  
  def test_audio_not_mute
    visual = get_default_visual() #Visual.new(1, "video", "", 0, 0, 1, false, 100)
    visual.mute=(false)
    assert_equal(true, visual.audio?)
  end
  
  def test_volume_zero
    visual = Visual.new(1, "video", "", 0, 0, 1, true, 0)
    assert_equal(false, visual.audio?)
  end
  
  def test_image_visual
    visual = Visual.new(1, "image", "", 0, 0, 1, false, 100)
    assert_equal(false, visual.audio?)
  end
  
  def test_timeline_end_point
    visual = get_default_visual()
    assert_equal("0:0:10:0", visual.timeline_end_point.timeCodeStr)
  end
  
  def test_length_in_seconds
    visual = get_default_visual()
    visual.end_point=(TimeCode.new("01:01:01:100"))
    assert_equal(3661, visual.length_in_seconds)
  end
  
end
