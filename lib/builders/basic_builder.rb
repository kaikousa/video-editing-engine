# Name: BasicBuilder 
# Author: Kai Kousa
# Description: Provides a base-class for other builders. As the datatypes
# used in both formats(sequenced and channeled) are the same, it is 
# good to share the same code.
 

class BasicBuilder
  
  #Reads the data from <visual></visual> - node
  #and creates a Visual - object from that data.
  def readVisual(visual)
    type = visual.attribute("type").to_s
    file = XPath.first(visual, "file").text
    startPoint = XPath.first(visual, "clip-start").text
    endPoint = XPath.first(visual, "clip-end").text
    place = XPath.first(visual, "place").text
    mute = XPath.first(visual, "mute").text
    if(mute == "true")
      mute = true
    elsif(mute == "false")
      mute = false
    end
    
    #If no VolumePoints are found, an empty array is given.
    #This signals Visual to create default volumepoints.
    volumePoints = []        
    XPath.each(visual, "volumepoints/volumepoint"){|volPoint|          
      volumePoints << readVolumePoint(volPoint)
    }
        
    #parse effects
    effects = []
    visualEffects = XPath.first(visual, "effects")
    visualEffects.each_element_with_text(){|element|
      effects << readEffect(element)
    }
      
    return Visual.new(type, file, startPoint, endPoint, place, mute, volumePoints, effects)
  end
  
  #Reads the data from <audio></audio> - node
  #and creates an Audio - object from that data.
  def readAudio(audio)
    file = XPath.first(audio, "file").text
    startPoint = XPath.first(audio, "start-point").text
    endPoint = XPath.first(audio, "end-point").text
    place = XPath.first(audio, "place").text

    #If no VolumePoints are found, an empty array is given.
    #This signals Audio to create default volumepoints.
    volumePoints = []        
    XPath.each(audio, "volumepoints/volumepoint"){|volPoint|
      volumePoints << readVolumePoint(volPoint)
    }
      
    return Audio.new(file, startPoint, endPoint, place, volumePoints)
  end
  
  #Reads the data from <effect></effect> - node
  #and creates a Effect - object from that data.
  def readEffect(effect)
    name = effect.attribute("name")
    effectStartPoint = effect.attribute("startPoint").to_s
    effectEndPoint = effect.attribute("endPoint").to_s
    parameters = {}
    effect.each_element_with_text(){|param|
      paramName = param.attribute("name").to_s
      paramValue = param.text
      parameters.merge!({paramName => paramValue}) #Add a new key-value - pair to existing hash
    }
    return Effect.new(name, effectStartPoint, effectEndPoint, parameters)
  end
  
  #Reads the data from <volumepoint></volumepoint> - node
  #and creates a VolumePoint - object from that data.
  def readVolumePoint(volumePoint)
    point = XPath.first(volumePoint, "point").text
    volume = XPath.first(volumePoint, "volume").text
    return VolumePoint.new(volume, point)
  end
  
end
