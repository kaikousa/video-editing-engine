# Name: BasicBuilder 
# Author: Kai Kousa
# Description: Provides a base-class for other builders. As the datatypes
# used in both formats(sequenced and channeled) are the same, it is 
# good to share the same code.
 

class BasicBuilder
  
  #Reads the data from <visual></visual> - node
  #and creates a Visual - object from that data.
  def read_visual(visual)
    type = visual.attribute("type").to_s
    file = XPath.first(visual, "file").text
    start_point = XPath.first(visual, "clip-start").text
    end_point = XPath.first(visual, "clip-end").text
    place = XPath.first(visual, "place").text
    mute = XPath.first(visual, "mute").text
    if(mute == "true")
      mute = true
    elsif(mute == "false")
      mute = false
    end
    
    #If no VolumePoints are found, an empty array is given.
    #This signals Visual to create default volumepoints.
    volume_points = []
    XPath.each(visual, "volumepoints/volumepoint"){|vol_point|
      volume_points << read_volume_point(vol_point)
    }
        
    #parse effects
    effects = []
    visual_effects = XPath.first(visual, "effects")
    visual_effects.each_element_with_text(){|element|
      effects << read_effect(element)
    }
      
    return Visual.new(type, file, start_point, end_point, place, mute, volume_points, effects)
  end
  
  #Reads the data from <audio></audio> - node
  #and creates an Audio - object from that data.
  def read_audio(audio)
    file = XPath.first(audio, "file").text
    start_point = XPath.first(audio, "start-point").text
    end_point = XPath.first(audio, "end-point").text
    place = XPath.first(audio, "place").text

    #If no VolumePoints are found, an empty array is given.
    #This signals Audio to create default volumepoints.
    volume_points = []
    XPath.each(audio, "volumepoints/volumepoint"){|vol_point|
      volume_points << read_volume_point(vol_point)
    }
      
    return Audio.new(file, start_point, end_point, place, volume_points)
  end
  
  #Reads the data from <effect></effect> - node
  #and creates a Effect - object from that data.
  def read_effect(effect)
    name = effect.attribute("name")
    effect_start_point = effect.attribute("startPoint").to_s
    effect_end_point = effect.attribute("endPoint").to_s
    parameters = {}
    effect.each_element_with_text(){|param|
      param_name = param.attribute("name").to_s
      param_value = param.text
      parameters.merge!({param_name => param_value}) #Add a new key-value - pair to existing hash
    }
    return Effect.new(name, effect_start_point, effect_end_point, parameters)
  end
  
  #Reads the data from <volumepoint></volumepoint> - node
  #and creates a VolumePoint - object from that data.
  def read_volume_point(volume_point)
    point = XPath.first(volume_point, "point").text
    volume = XPath.first(volume_point, "volume").text
    return VolumePoint.new(volume, point)
  end
  
end
