# Name: Vre
# Author: Kai Kousa
# Description: Main-class for rendering. This class parses the command-line 
# parameters and delegates tasks to other classes
# 
require 'movie_builder'
require 'movie_renderer'
require 'movie_normalizer'

class Vre
  def initialize
    
  end
  
  def main(xmlFile)
    builder = MovieBuilder.new
    builder.register(self)
    builder.buildMovie(xmlFile)
    movie = builder.movie
    
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
