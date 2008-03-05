#Name: Movie
#Author: Kai Kousa
#Description: Encapsulates data that the effects processor needs to know
#in order to apply the effect.
 

class Effect
  
  attr_reader(:name, :properties)
  
  def initialize(name, startPoint, endPoint, properties)
    @name = name
    @startPoint = startPoint
    @endPoint = endPoint
    @properties = properties
  end
  
end
