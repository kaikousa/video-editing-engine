#Name: Movie
#Author: Kai Kousa
#Description: Movie is a wrapper class to hold audio- and videosequences
#that compose a movie.
require 'model/audio_sequence'
require 'model/visual_sequence'
require 'model/project'

class Movie
  
  attr_reader(:name, :format, :resolution, :audio_sequence, :visual_sequence, :effects, :project, :width, :height)
  
  def initialize(name, format, resolution)
    @name = name
    @format = format
    @resolution = resolution
    @audio_sequence = AudioSequence.new
    @visual_sequence = VisualSequence.new
    @effects = []
    @project = Project.new(@name)
    set_width_and_height(@resolution)
  end
  
  def visual_sequence=(visual_sequence)
    @visual_sequence = visual_sequence
  end
  
  def audio_sequence=(audio_sequence)
    @audio_sequence = audio_sequence
  end
  
  def effects=(effects)
    @effects = effects
  end
  
  def audio_longer_than_video?()
    sorted_visuals = @visual_sequence.sort
    sorted_audios = @audio_sequence.sort
    
    if sorted_audios.length == 0 or sorted_visuals.length == 0
      return false
    end
    
    last_audio = sorted_audios[sorted_audios.length - 1]
    last_visual = sorted_visuals[sorted_visuals.length - 1]
    if (last_audio.place.milliseconds + last_audio.length) > (last_visual.place.milliseconds + last_visual.length)
      return true
    else
      return false
    end
  end
  
  def to_str()
    "\nName: #{@name}\nFormat: #{@format}\nResolution: #{@resolution}\n\n"
  end
  
  def set_width_and_height(resolution)
      width_and_height = resolution.split('x')
      @width = width_and_height[0]
      @height = width_and_height[1]
  end
  private :set_width_and_height
end
