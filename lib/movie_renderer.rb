# Name: MovieRenderer
# Author: Kai Kousa
# Description: MovieRenderer is responsible for directing the rendering process.

require 'tools/video_tools'
require 'tools/audio_tools'
require 'model/audio_sequence'
require 'observable'
include Observable

class MovieRenderer
  
  def initialize
    @videoTool = VideoTools.new
    @audioTool = AudioTools.new
  end
  
  def render(movie)
    updateAll("MovieRenderer", "Processing audio...")
    audioFile = processAudio(movie)
    updateAll("MovieRenderer", "...audioprocessing finished!")
    
    updateAll("MovieRenderer", "Processing effects...")
    processEffects(movie)
    updateAll("MovieRenderer", "...effects finished!")
    
    updateAll("MovieRenderer", "Processing visuals...")
    videoFile = processVisuals(movie)
    updateAll("MovieRenderer", "...videoprocessing finished!")
    
    updateAll("MovieRenderer", "Multiplexing audio and video...")
    @videoTool.multiplex(videoFile, audioFile, movie.format)
    updateAll("MovieRenderer", "...multiplexing finished")
    
    updateAll("MovieRenderer", "Rendering finished!(not really...)")
  end
  
  #Convert -> Trim -> Combine -> Result: Audiotrack
  def processAudio(movie)
    audios = movie.audioSequence.sort
    audios.each{|audio|
      @audioTool.convertAudio(audio, movie.project)
      @audioTool.trimAudio(audio, movie.project)
    }
    audioSequence = AudioSequence.new
    audioSequence.audios=(audios)
    movie.audioSequence=(audioSequence)
    @audioTool.mixAudioSequence(audioSequence, movie.project)
  end
  
  #Trim/generate -> Combine -> Result: Videotrack
  def processVisuals(movie)
    visuals = movie.visualSequence.sort
    visuals.each {|visual|
      if(visual.type == "video")
        @videoTool.trimVideo(movie, visual)
      elsif(visual.type == "image")
        @videoTool.createVideoFromImage(movie, visual)
      elsif(visual.type == "blackness")
        @videoTool.createVideoFromScratch(movie, visual, "")
      end
    }
    sequence = VisualSequence.new
    sequence.visuals=(visuals)
    @videoTool.combineVideo(sequence)
  end
  
  def processEffects(movie)
    
  end
  
end
