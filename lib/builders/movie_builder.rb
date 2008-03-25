#Name: MovieBuilder 
#Author: Kai Kousa
#Description: MovieBuilder takes in an xml-file and creates an object model
#of the movie. This model is then processed so that we end up with separate
# audio and videosequences.
require "rexml/document"
include REXML
require "model/movie"
require "model/effect"
require "channeled_builder"
require "sequenced_builder"
require "observable"
include Observable

class MovieBuilder
  
  attr_reader(:movie)
  
  def initialize
    
  end
  
  #Builds the object model from the given xml-file
  #ToDo: Validate xml
  def buildMovie(xmlFile)
    updateAll("MovieBuilder", "Reading the object model from xml(#{xmlFile})...")
    xml = Document.new(File.open(xmlFile))
    
    e = XPath.first(xml, "movie")
    timelineFormat = e.attribute("type").to_s #Get the attribute and convert to string
    fileVersion = e.attribute("version")
    
    #updateAll("Filetype: #{fileType} Version: #{fileVersion}")
    
    name = XPath.first(xml, "//metadata/name").text
    format = XPath.first(xml, "//metadata/format").text
    resolution = XPath.first(xml, "//metadata/resolution").text
    
    @movie = Movie.new(name, format, resolution)
    
    if(timelineFormat == "channeled")
      updateAll("MovieBuilder", "Building an object model from channeled timeline-format...")
      channeledBuilder = ChanneledBuilder.new
      @movie = channeledBuilder.buildMovie(xml, @movie)
    elsif(timelineFormat == "sequenced")
      updateAll("MovieBuilder", "Building an object model from sequenced timeline-format...")
      sequencedBuilder = SequencedBuilder.new
      @movie = sequencedBuilder.buildMovie(xml, @movie)
    else
      updateAll("MovieBuilder", "Unknown timeline-format(#{timelineFormat})")
    end

    updateAll("MovieBuilder", "...object model finished!")
    
    return @movie
  end
  
end
