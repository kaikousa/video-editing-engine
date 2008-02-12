#Name: Movie
#Author: Kai Kousa
#Description: Movie is a wrapper class to hold audio- and videosequences
#that compose a movie.
require 'audio_sequence'
require 'visual_sequence'

class Movie
  
  attr_reader(:name, :format, :resolution, :audioSequence, :visualSequence, :effects)
  
  def initialize(name, format, resolution)
    @name = name
    @format = format
    @resolution = resolution
    @audioSequence = AudioSequence.new
    @visualSequence = VisualSequence.new
    @effects = []    
  end
  
  def visualSequence=(visualSequence)
    @visualSequence = visualSequence
  end
  
  def audioSequence=(audioSequence)
    @audioSequence = audioSequence
  end
  
  def effects=(effects)
    @effects = effects
  end
  
  def to_str()
    "\nName: #{@name}\nFormat: #{@format}\nResolution: #{@resolution}\n\n"
  end
  
end
