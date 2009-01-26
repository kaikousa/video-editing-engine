#Name: Movie
#Author: Kai Kousa
#Description: Encapsulates data that the effects processor needs to know
#in order to apply the effect.
require "model/time_code"

class Effect
  
  attr_reader(:name, :properties, :end_point, :start_point)
  
  def initialize(name, start_point, end_point, properties)
    @name = name
    @start_point = TimeCode.new(start_point)
    @end_point = TimeCode.new(end_point)
    @properties = properties
  end
  
end
