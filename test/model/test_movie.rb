# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'test/unit'
require "model/movie"
require "model/visual"
require "model/audio"

class TestMovie < Test::Unit::TestCase
  
  def test_audio_longer_than_video
    video = Visual.new("video", "nil", "00:00:00:00", "00:00:10:00", "00:00:00:00", false, [], [])
    audio = Audio.new("nil", "00:00:00:00", "00:00:20:00", "00:00:00:00", [])
    movie = Movie.new("Test", "mp4", "720x576")
    movie.visual_sequence.add_video(video)
    movie.audio_sequence.add_audio(audio)
    assert_equal(true, movie.audio_longer_than_video?)
  end
  
end
