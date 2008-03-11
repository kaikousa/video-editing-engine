# Name: MovieRenderer
# Author: Kai Kousa
# Description:

require 'observable'
include Observable

class MovieRenderer
  
  def initialize
    
  end
  
  def render(movie)
    updateAll("MovieRenderer", "Rendering finished!(not really...)")
  end
  
end
