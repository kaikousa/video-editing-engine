# Name: BasicBuilder 
# Author: Kai Kousa
# Description: Provides a base-class for other builders. As the datatypes
# used in both formats(sequenced and channeled) are the same, it is 
# good to share the same code.
 

class BasicBuilder
  def readVisual(visual)
    type = visual.attribute("type")
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
  
  def readAudio(audio)
    file = XPath.first(audio, "file").text
    startPoint = XPath.first(audio, "start-point").text
    endPoint = XPath.first(audio, "end-point").text
    place = XPath.first(audio, "place").text

    volumePoints = []        
    XPath.each(audio, "volumepoints/volumepoint"){|volPoint|
      volumePoints << readVolumePoint(volPoint)
    }
      
    return Audio.new(file, startPoint, endPoint, place, volumePoints)
  end
  
  def readEffect(effect)
    name = effect.attribute("name")
    effectStartPoint = effect.attribute("startPoint").to_s
    effectEndPoint = effect.attribute("endPoint").to_s
    parameters = {}
    effect.each_element_with_text(){|param|
    paramName = param.attribute("name")
    paramValue = param.text
      parameters.merge!({paramName => paramValue})
    }
    return Effect.new(name, effectStartPoint, effectEndPoint, parameters)
  end
  
  def readVolumePoint(volumePoint)
    point = XPath.first(volumePoint, "point").text
    volume = XPath.first(volumePoint, "volume").text
    return VolumePoint.new(volume, point)
  end
  
end
