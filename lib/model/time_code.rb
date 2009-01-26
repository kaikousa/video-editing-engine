#Name: TimeCode
#Author: Kai Kousa
#Description: Encapsulates TimeCodes and provides tools to convert
#string representations to more useful formats. Stores the time in 
#milliseconds and in string-representation.
 

class TimeCode
  
  attr_reader(:time_code_str, :milliseconds)
  
  def initialize(time_code)
    if time_code.instance_of?(String)
      self.time_code_str = time_code
    elsif time_code.instance_of?(Fixnum)
      self.milliseconds = time_code
    elsif time_code.instance_of?(Integer)
      self.milliseconds = time_code
    elsif time_code.instance_of?(TimeCode)
      self.milliseconds = time_code.milliseconds
    end
  end
  
  #Converts string-formatted time code to milliseconds
  def convert_to_ms()
    split = @time_code_str.split(":")
    
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
  private :convert_to_ms
  
  #Set the TimeCode in milliseconds
  def milliseconds=(ms)
    @milliseconds = ms

    hours = ms / 3600000 #1 hour == 3 600 000 ms
    ms = ms - (hours * 3600000) 
    minutes = ms / 60000 #1 minute == 60 000 ms
    ms = ms - (minutes * 60000)
    seconds = ms / 1000 #1 second == 1000 ms
    ms = ms - (seconds * 1000)
    @time_code_str = "#{hours}:#{minutes}:#{seconds}:#{ms}"
  end
  
  #Return the String representation of this TimeCode(h:min:sec:ms)
  def time_code_str=(str)
    @time_code_str = str
    @milliseconds = convert_to_ms()
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
  
  def to_frames(fps)
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
    @time_code_str
  end
  
  def to_str
    to_s()
  end
  
end
