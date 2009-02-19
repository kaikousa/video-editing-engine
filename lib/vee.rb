# Name: Vre
# Author: Kai Kousa
# Description: Main-class for rendering. This class parses the command-line 
# parameters and delegates tasks to other classes
# 
require 'builders/movie_builder'
require 'movie_renderer'
require 'movie_normalizer'
require 'tools/folder_manager'

class Vee
  def initialize
    
  end
  
  def process_movie_file(movie_file)
    builder = MovieBuilder.new
    builder.register(self)
    movie = builder.build_movie(movie_file)
    if(movie != nil)
      process_movie(movie)
    end
  end
  
  def process_movie(movie)
    folder_manager = FolderManager.new
    folder_manager.create_project_layout(movie.project)
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
    puts "\tVisuals: #{movie.visual_sequence.visuals.length}" 
    puts "\tAudios: #{movie.audio_sequence.audios.length}"
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
