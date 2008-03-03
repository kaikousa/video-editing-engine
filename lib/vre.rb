# Name: Vre
# Author: Kai Kousa
# Description: Main-class for rendering. This class parses the command-line 
# parameters and delegates tasks to other classes
# 
require 'movie_builder'
require "observer"
include Observer

class Vre
  def initialize
    
  end
  
  def main()
    builder = MovieBuilder.new
    builder.register(self)
    builder.buildMovie('movie-example.xml')
    movie = builder.movie
    
    puts "A movie model was generated. The details:"
    puts movie.to_str
    puts "Contains:"
    puts "Visuals: #{movie.visualSequence.visuals.length}" 
    puts "Audios: #{movie.audioSequence.audios.length}"
    puts "Effects: #{movie.effects.length}"
  end
  
  def update(message)
    puts "Builder: #{message}"
  end
end
