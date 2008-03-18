# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'model/visual'

class VisualSequence
  
  attr_reader :visuals 
  
  def initialize()
    @visuals = []
  end
  
  def addVideo(visual)
    @visuals << visual
  end
  
  def visuals=(visuals)
    @visuals = visuals
  end
  
  def sort
    @visuals.sort{|x, y| x.place.milliseconds <=> y.place.milliseconds}
  end
  
  def to_str()
    text = "VisualSequence: \n"
    @visuals.each{|visual| text + visual.to_str}
    text
  end
  
end
