#Name: ChanneledBuilder 
#Author: Kai Kousa
#Description: Parses a Movie from channeled-timeline-format. In channeled-format
#audios and videos are put on separate channels that can contain more channels.
 
require "rexml/document"
include REXML
require "model/movie"
require "model/effect"
require "model/volume_point"
require "builders/basic_builder"
require "observable"
include Observable

class ChanneledBuilder < BasicBuilder
  def initialize
    
  end
  
  def build_movie(xml, movie)
    
    #Parse a visual sequence from xml
    visual_sequence = VisualSequence.new
    video_channels = XPath.first(xml, "/movie/video-channels")
    XPath.each(video_channels, "channel"){ |channel|
      XPath.each(channel, "visual"){|visual|
        visual_sequence.addVideo(read_visual(visual))
      }     
    }
    movie.visual_sequence = visual_sequence
    
    #Parse audio sequence from xml
    audio_sequence = AudioSequence.new
    audio_channels = XPath.first(xml, "/movie/audio-channels")
    XPath.each(audio_channels, "channel"){ |channel|
      XPath.each(channel, "audio"){|audio|
        audio_sequence.add_audio(read_audio(audio))
      } 
    }
    movie.audio_sequence = audio_sequence #Add the parsed audiosequence to movie
 
    return movie
  end
  
end