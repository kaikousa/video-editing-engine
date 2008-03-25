#Name: SequencedBuilder 
#Author: Kai Kousa
#Description: Builds a movie from xml-format that has every element mixed
#in the same sequence.

require "rexml/document"
include REXML
require "model/movie"
require "model/effect"
require "model/volume_point"
require "builders/basic_builder"
require "observable"
include Observable 

class SequencedBuilder < BasicBuilder
  def initialize
    
  end
  
  def buildMovie(xml, movie)
    #Parse a visual sequence from xml
    visualSequence = VisualSequence.new
    XPath.each(xml, "/movie/sequence/visual"){ |visual| 
      visualSequence.addVideo(readVisual(visual)) 
    }
    movie.visualSequence=(visualSequence)
    
    #Parse audio sequence from xml
    audioSequence = AudioSequence.new
    XPath.each(xml, "/movie/sequence/audio"){ |audio| 
      audioSequence.addAudio(readAudio(audio))      
    }
    movie.audioSequence=(audioSequence)#Add the parsed audiosequence to movie
    
    return movie
  end
  
end