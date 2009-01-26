# Name: TestAudio
# Author: Kai Kousa
# Description: Test cases for Audio-class
require 'model/audio'
require 'test/unit'

class TestAudio < Test::Unit::TestCase
  
  def test_audio
    audio = Audio.new("", "00:00:00:00", "00:00:00:00", "00:00:00:00", [])
  end
  
end
