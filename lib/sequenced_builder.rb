#Name: SequencedBuilder 
#Author: Kai Kousa
#Description:

require "rexml/document"
include REXML
require "model/movie"
require "model/effect"
require "model/volume_point"
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
      
      volumePoints = []
        
      XPath.each(e, "volumepoints/volumepoint"){|volPoint|
        point = XPath.first(volPoint, "point").text
        volume = XPath.first(volPoint, "volume").text
        volumePoints << VolumePoint.new(volume, point)
     }
      
      #parse effects
      effects = []
      visualEffects = XPath.first(e, "effects")
      visualEffects.each_element_with_text(){|element|
        name = element.attribute("name")
        effectStartPoint = element.attribute("startPoint").to_s
        effectEndPoint = element.attribute("endPoint").to_s
        parameters = {}
        element.each_element_with_text(){|param|
          paramName = param.attribute("name")
          paramValue = param.text
          parameters.merge!({paramName => paramValue})
        }
        effect = Effect.new(name, effectStartPoint, effectEndPoint, parameters)
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
      place = XPath.first(e, "place").text
      
      volumePoints = []
        
      XPath.each(e, "volumepoints/volumepoint"){|volPoint|
        point = XPath.first(volPoint, "point").text
        volume = XPath.first(volPoint, "volume").text
        volumePoints << VolumePoint.new(volume, point)
      }
      
      audio = Audio.new(file, startPoint, endPoint, place, volumePoints)
      #puts audio.to_str
      audioSequence.addAudio(audio)      
    }
    movie.audioSequence=(audioSequence)#Add the parsed audiosequence to movie
    
    return movie
  end
  
end
