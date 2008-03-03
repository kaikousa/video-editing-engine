#Name: Movie
#Author: Kai Kousa
#Description: Encapsulates data that the effects processor needs to know
#in order to apply the effect.
 

class Effect
  
  attr_reader(:type, :properties)
  
  def initialize(type, properties)
    @type = type
    @properties = properties
  end
  
end
