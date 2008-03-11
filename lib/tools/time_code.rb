#Name: TimeCode
#Author: Kai Kousa
#Description: Encapsulates TimeCodes and provides tools to convert
#string representations to more useful formats
 

class TimeCode
  
  attr_reader(:timeCodeStr)
  
  def initialize(timeCodeStr)
    @timeCodeStr = timeCodeStr
  end
  
  #Converts string-formatted time code to milliseconds
  def convertToMs()
    split = @timeCodeStr.split(":")
    
    hours = split[0].to_i
    minutes = split[1].to_i
    seconds = split[2].to_i
    milliseconds = split[3].to_i
    
    #puts "Hours: #{hours} Minutes: #{minutes} Seconds: #{seconds} Milliseconds: #{milliseconds}"
    
    milliseconds += seconds * 1000;
    milliseconds += (minutes * 60) * 1000
    milliseconds += (hours * 60 * 60) * 1000    
    
    return milliseconds
  end
end
