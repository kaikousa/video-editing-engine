#Name: MovieBuilder 
#Author: Kai Kousa
#Description: MovieBuilder takes in an xml-file and creates an object model
#of the movie. This model is then processed so that we end up with separate
# audio and videosequences.
require "rexml/document"
include REXML
require "movie"
require "effect"

class MovieBuilder
  
  attr_reader(:movie)
  
  def initialize
    
  end
  
  #Builds the object model from the given xml-file
  #ToDo: Validate xml
  def buildMovie(xmlFile)
    xml = Document.new(File.open(xmlFile))
    
    name = XPath.first(xml, "//name").text
    format = XPath.first(xml, "//format").text
    resolution = XPath.first(xml, "//resolution").text
    
    @movie = Movie.new(name, format, resolution)
    
    #Parse a visual sequence from xml
    visualSequence = VisualSequence.new
    visuals = XPath.first(xml, "//visual-sequence")
    XPath.each(visuals, "visual"){ |e| 
      type = e.attribute("type")
      index = e.attribute("index")
      file = XPath.first(e, "file").text
      startPoint = XPath.first(e, "start-point").text
      endPoint = XPath.first(e, "end-point").text
      place = XPath.first(e, "place").text
      mute = XPath.first(e, "mute").text
      volume = XPath.first(e, "volume").text
      
      visual = Visual.new(index, type, file, startPoint, endPoint, place, mute, volume)
      #puts visual.to_str
      visualSequence.addVideo(visual)      
    }
    @movie.visualSequence=(visualSequence)
    
    #Parse audio sequence from xml
    audioSequence = AudioSequence.new
    audios = XPath.first(xml, "//audio-sequence")
    XPath.each(audios, "audio"){ |e| 
      file = XPath.first(e, "file").text
      startPoint = XPath.first(e, "start-point").text
      endPoint = XPath.first(e, "end-point").text
      volume = XPath.first(e, "volume").text
      offset = XPath.first(e, "offset").text
      
      audio = Audio.new(file, volume, startPoint, endPoint, offset)
      #puts audio.to_str
      audioSequence.addAudio(audio)      
    }
    @movie.audioSequence=(audioSequence)#Add the parsed audiosequence to movie
    
    #Parse visual effects from xml
    effects = []
    visualEffects = XPath.first(xml, "//visual-effects")
    XPath.each(visualEffects, "effect"){|e|
      type = e.attribute("type")
      properties = {}
      e.each_element_with_text() { |element| 
        name = element.attribute("name")
        value = element.text
        properties.merge!({ name => value }) #Add a new property to the existing properties
        #puts "name: #{name} value: #{value}"  
      }       
      effect = Effect.new(type, properties)
      effects << effect #Push the new Effect to effects-array
    }
    @movie.effects = effects
    
    #visuals.each_element_with_text{|e| puts e} 
    return @movie
  end
  
end
