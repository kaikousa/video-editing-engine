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
  
  def build_movie(xml, movie)
    #Parse a visual sequence from xml
    visual_sequence = VisualSequence.new
    XPath.each(xml, "/movie/sequence/visual"){ |visual| 
      visual_sequence.addVideo(read_visual(visual))
    }
    movie.visual_sequence = visual_sequence
    
    #Parse audio sequence from xml
    audio_sequence = AudioSequence.new
    XPath.each(xml, "/movie/sequence/audio"){ |audio| 
      audio_sequence.add_audio(read_audio(audio))
    }
    movie.audio_sequence = audio_sequence #Add the parsed audiosequence to movie
    
    return movie
  end
  
end