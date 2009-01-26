# Name: Vre
# Author: Kai Kousa
# Description: Main-class for rendering. This class parses the command-line 
# parameters and delegates tasks to other classes
# 
require 'builders/movie_builder'
require 'movie_renderer'
require 'movie_normalizer'
require 'tools/folder_manager'

class Vre
  def initialize
    
  end
  
  def process_xml(xmlFile)
    builder = MovieBuilder.new
    builder.register(self)
    movie = builder.buildMovie(xmlFile)
    process_movie(movie)
  end
  
  def process_movie(movie)
    folder_manager = FolderManager.new
    folder_manager.createProjectLayout(movie.project)
    puts "Created folders for the project in workspace: #{movie.project.root}"
    normalizer = MovieNormalizer.new
    normalizer.register(self)
    puts "Begin normalization..."
    movie = normalizer.normalize(movie)
    puts "... normalization finished!"
            
    puts "\nA movie model was generated. The details:"
    puts "\n\tName: #{movie.name}" 
    puts "\tFormat: #{movie.format}"
    puts "\tResolution: #{movie.resolution}"
    puts "\n\tContains:"
    puts "\tVisuals: #{movie.visualSequence.visuals.length}" 
    puts "\tAudios: #{movie.audioSequence.audios.length}"
    puts "\tEffects: #{movie.effects.length}"
    
    puts "\nProceeding to rendering process..."
    
    renderer = MovieRenderer.new
    renderer.register(self)
    renderer.render(movie)
  end
  
  def update(sender, message)
    puts "#{sender}: #{message}"
  end
end

#This section is for launching the VRE on the command line.

puts "\nVideo Rendering Engine (v.0.1-alpha)"
puts ""

xml_file = ARGV[0]
if(xml_File == nil)
  puts "Parameter missing!"
  puts "USAGE: ruby vre <xmlfile>"
  puts ""
else
  start = Time.now

  vre = Vre.new()
  vre.process_xml(xml_file)

  stop = Time.now
  puts "It took #{stop - start} seconds to finish"
end
