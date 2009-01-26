# Name: VisualSequence
# Author: Kai Kousa
# Description: Encapsulates a collection of visuals and provides useful methods.
require 'model/visual'

class VisualSequence
  
  attr_reader :visuals 
  
  def initialize()
    @visuals = []
    @sorted = false
  end
  
  def add_video(visual)
    @visuals << visual
    @sorted = false
  end
  
  def visuals=(visuals)
    @visuals = visuals
    @sorted = false
  end
  
  def sort
    #if the sequence hasn't changed since last sort, do not sort again
    unless @sorted
      @visuals = @visuals.sort{|x, y| x.place.milliseconds <=> y.place.milliseconds}
      @sorted = true
    end    
    @visuals
  end
  
  def to_str()
    text = "VisualSequence: \n"
    @visuals.each{|visual| text + visual.to_str}
    text
  end
  
end
