#Name: TimeCode
#Author: Kai Kousa
#Description: Encapsulates TimeCodes and provides tools to convert
#string representations to more useful formats. Stores the time in 
#milliseconds and in string-representation.
 

class TimeCode
  
  attr_reader(:timeCodeStr, :milliseconds)
  
  def initialize(timeCode)
    if timeCode.instance_of?(String)
      self.timeCodeStr = timeCode
    elsif timeCode.instance_of?(Fixnum)
      self.milliseconds = timeCode
    elsif timeCode.instance_of?(Integer)
      self.milliseconds = timeCode
    elsif timeCode.instance_of?(TimeCode)
      self.milliseconds = timeCode.milliseconds
    end
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
  private :convertToMs
  
  #Set the TimeCode in milliseconds
  def milliseconds=(ms)
    @milliseconds = ms

    hours = ms / 3600000 #1 hour == 3 600 000 ms
    ms = ms - (hours * 3600000) 
    minutes = ms / 60000 #1 minute == 60 000 ms
    ms = ms - (minutes * 60000)
    seconds = ms / 1000 #1 second == 1000 ms
    ms = ms - (seconds * 1000)
    @timeCodeStr = "#{hours}:#{minutes}:#{seconds}:#{ms}"
  end
  
  #Return the String representation of this TimeCode(h:min:sec:ms)
  def timeCodeStr=(str)
    @timeCodeStr = str
    @milliseconds = convertToMs()
  end
  
  def seconds()
    ms = @milliseconds
    hours = ms / 3600000
    ms = ms - (hours * 3600000) 
    minutes = ms / 60000 
    ms = ms - (minutes * 60000)
    seconds = ms / 1000
    ms = ms - (seconds * 1000)
    
    if(ms > 499)
      seconds += 1
    end
    
    return (hours * 60 * 60) + (minutes * 60) + seconds
  end
  
  #Add the value of another TimeCode to this and return the result
  def +(other)
    TimeCode.new(@milliseconds + other.milliseconds)
  end
  
  #Remove the value of another TimeCode from this and return the result
  def -(other)
    TimeCode.new(@milliseconds - other.milliseconds)
  end
  
  def toFrames(fps)
    ms = @milliseconds
    hours = ms / 3600000
    ms = ms - (hours * 3600000) 
    minutes = ms / 60000 
    ms = ms - (minutes * 60000)
    seconds = ms / 1000
    ms = ms - (seconds * 1000)    
    
    frames  = hours * 3600 * fps
    frames += minutes * 60 * fps
    frames += seconds * fps
    frames += (fps.to_f * (ms.to_f / 1000)).round
    return frames
  end
  
  def to_s
    @timeCodeStr
  end
  
  def to_str
    to_s()
  end
  
end
