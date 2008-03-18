# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'test/unit'
require "../lib/model/movie"
require "../lib/model/visual"
require "../lib/model/audio"

class TestMovie < Test::Unit::TestCase
  
  def testAudioLongerThanVideo
    video = Visual.new("video", "nil", "00:00:00:00", "00:00:10:00", "00:00:00:00", false, [], [])
    audio = Audio.new("nil", "00:00:00:00", "00:00:20:00", "00:00:00:00", [])
    movie = Movie.new("Test", "mp4", "720x576")
    movie.visualSequence.addVideo(video)
    movie.audioSequence.addAudio(audio)
    assert_equal(true, movie.audioLongerThanVideo?)
  end
  
end
