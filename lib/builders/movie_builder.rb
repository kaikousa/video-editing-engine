#Name: MovieBuilder 
#Author: Kai Kousa
#Description: MovieBuilder takes in an xml-file and creates an object model
#of the movie. This model is then processed so that we end up with separate
# audio and videosequences.
require "rexml/document"
include REXML
require "model/movie"
require "model/effect"
require "builders/channeled_builder"
require "builders/sequenced_builder"
require "builders/json_builder"
require "observable"
include Observable

class MovieBuilder
  
  attr_reader(:movie)
  
  def initialize
    
  end
  
  #Builds the object model from the given xml-file
  #ToDo: Validate xml
  def build_movie(movie_file)
    extension = File.extname(movie_file)
    if(extension == ".xml")
      return build_from_xml(movie_file)
    elsif(extension == ".json")
      update_all("MovieBuilder", "Creating movie from JSON")
      json_builder = JSONBuilder.new
      return json_builder.build_movie(movie_file)
    else
      update_all("MovieBuilder", "Unknown extension. See documentation for supported formats and markups")
    end
    return nil
  end
  
  def build_from_xml(xml_file)
    update_all("MovieBuilder", "Reading the object model from xml(#{xml_file})...")
    xml = Document.new(File.open(xml_file))
    
    e = XPath.first(xml, "movie")
    timeline_format = e.attribute("type").to_s #Get the attribute and convert to string
    file_version = e.attribute("version")
    
    #update_all("Filetype: #{fileType} Version: #{fileVersion}")
    
    name = XPath.first(xml, "//metadata/name").text
    format = XPath.first(xml, "//metadata/format").text
    resolution = XPath.first(xml, "//metadata/resolution").text
    
    @movie = Movie.new(name, format, resolution)
    
    if(timeline_format == "channeled")
      update_all("MovieBuilder", "Building an object model from channeled timeline-format...")
      channeled_builder = ChanneledBuilder.new
      @movie = channeled_builder.build_movie(xml, @movie)
    elsif(timeline_format == "sequenced")
      update_all("MovieBuilder", "Building an object model from sequenced timeline-format...")
      sequenced_builder = SequencedBuilder.new
      @movie = sequenced_builder.build_movie(xml, @movie)
    else
      update_all("MovieBuilder", "Unknown timeline-format(#{timeline_format})")
    end

    update_all("MovieBuilder", "...object model finished!")
    
    return @movie
  end
  
end
