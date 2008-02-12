# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'audio'

class AudioSequence
  
  attr_reader :audios 
  
  def initialize()
    @audios = []
  end
  
  def addAudio(audio)
    @audios << audio
  end

end
