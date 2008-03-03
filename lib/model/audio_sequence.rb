# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'model/audio'

class AudioSequence
  
  attr_reader :audios 
  
  def initialize()
    @audios = []
  end
  
  def addAudio(audio)
    @audios << audio
  end

end
