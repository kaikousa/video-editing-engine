#Name: Movie
#Author: Kai Kousa
#Description: Encapsulates data that the effects processor needs to know
#in order to apply the effect.
require "model/time_code"

class Effect
  
  attr_reader(:name, :properties, :endPoint, :startPoint)
  
  def initialize(name, startPoint, endPoint, properties)
    @name = name
    @startPoint = TimeCode.new(startPoint)
    @endPoint = TimeCode.new(endPoint)
    @properties = properties
  end
  
end
