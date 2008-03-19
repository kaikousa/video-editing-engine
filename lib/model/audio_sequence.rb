# Name: AudioSequence
# Author: Kai Kousa
# Description: Encapsulates a collection of audios and provides useful methods.
require 'model/audio'

class AudioSequence
  
  attr_reader :audios 
  
  def initialize()
    @audios = []
    @sorted = false
  end
  
  def addAudio(audio)
    @audios << audio
    @sorted = false
  end
  
  def audios=(audios)
    @audios = audios
    @sorted = false
  end
  
  def sort
    #if the sequence hasn't changed since last sort, do not sort again
    unless @sorted
      @audios = @audios.sort{|x, y| x.place.milliseconds <=> y.place.milliseconds}
      @sorted = true
    end    
    @audios
  end

end
