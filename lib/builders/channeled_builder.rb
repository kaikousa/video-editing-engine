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
  
  def buildMovie(xml, movie)
    
    #Parse a visual sequence from xml
    visualSequence = VisualSequence.new
    videoChannels = XPath.first(xml, "/movie/video-channels")
    XPath.each(videoChannels, "channel"){ |channel| 
      XPath.each(channel, "visual"){|visual|
        visualSequence.addVideo(readVisual(visual)) 
      }     
    }
    movie.visualSequence=(visualSequence)
    
    #Parse audio sequence from xml
    audioSequence = AudioSequence.new
    audioChannels = XPath.first(xml, "/movie/audio-channels")
    XPath.each(audioChannels, "channel"){ |channel| 
      XPath.each(channel, "audio"){|audio|
        audioSequence.addAudio(readAudio(audio))       
      } 
    }
    movie.audioSequence=(audioSequence)#Add the parsed audiosequence to movie
 
    return movie
  end
  
end