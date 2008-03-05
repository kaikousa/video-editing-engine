#Name: SequencedBuilder 
#Author: Kai Kousa
#Description:

require "rexml/document"
include REXML
require "model/movie"
require "model/effect"
require "observable"
include Observable 

class SequencedBuilder
  def initialize
    
  end
  
  def buildMovie(xml, movie)
    #Parse a visual sequence from xml
    visualSequence = VisualSequence.new
    XPath.each(xml, "/movie/sequence/visual"){ |e| 
      type = e.attribute("type")
      file = XPath.first(e, "file").text
      startPoint = XPath.first(e, "clip-start").text
      endPoint = XPath.first(e, "clip-end").text
      place = XPath.first(e, "place").text
      mute = XPath.first(e, "mute").text
      
      volume = XPath.first(e, "volumepoints")
      volumePoints = {}
      volume.each_element_with_text(){|element|
        point = element.attribute("point")
        value = element.text
        volumePoints.merge!({point => value})
      }
      
      #parse effects
      effects = []
      visualEffects = XPath.first(e, "effects")
      visualEffects.each_element_with_text(){|element|
        name = element.attribute("name")
        startPoint = element.attribute("startPoint")
        endPoint = element.attribute("endPoint")
        parameters = {}
        element.each_element_with_text(){|param|
          paramName = param.attribute("name")
          paramValue = param.text
          parameters.merge!({paramName => paramValue})
        }
        effect = Effect.new(name, startPoint, endPoint, parameters)
        effects << effect
      }
      
      visual = Visual.new(type, file, startPoint, endPoint, place, mute, volumePoints, effects)
      visualSequence.addVideo(visual) 
      
    }
    movie.visualSequence=(visualSequence)
    
    #Parse audio sequence from xml
    audioSequence = AudioSequence.new
    XPath.each(xml, "/movie/sequence/audio"){ |e| 
      file = XPath.first(e, "file").text
      startPoint = XPath.first(e, "start-point").text
      endPoint = XPath.first(e, "end-point").text
      offset = XPath.first(e, "offset").text
      
      volume = XPath.first(e, "volumepoints")
      volumePoints = {}
      volume.each_element_with_text(){|element|
        point = element.attribute("point")
        value = element.text
        volumePoints.merge!({point => value})
      }
      
      audio = Audio.new(file, volume, startPoint, endPoint, offset, volumePoints)
      #puts audio.to_str
      audioSequence.addAudio(audio)      
    }
    movie.audioSequence=(audioSequence)#Add the parsed audiosequence to movie
    
    return movie
  end
  
end
