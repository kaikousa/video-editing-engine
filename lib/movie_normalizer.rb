#Name: MovieNormalizer
#Author: Kai Kousa
#Description: Contains all methods needed for the normalization of a videoproject.
require "observable"
include Observable

class MovieNormalizer
  def initialize
    
  end
  
  def normalize(movie)
    stripAudio(movie)
  
    updateAll("MovieNormalizer", "Searching for overlapping visuals...")
    overlapped = mergeVisuals(movie)
    
    updateAll("MovieNormalizer", "...found and edited #{overlapped} overlapped visuals!")

    updateAll("MovieNormalizer", "Searching for gaps...")
    
    gaps = fillGaps(movie)
    
    updateAll("MovieNormalizer", "...found and filled #{gaps} gaps!")    
    
    if(movie.audioLongerThanVideo?)
      truncateEndOfVideoTrack(movie)
      updateAll("MovieNormalizer", "Audiotrack is longer than the videotrack! Added black screen to the end of videotrack.")
    end
    
    return movie
  end
  
  #Create Audio-objects from Visuals that have audiotracks and adds them to the movie
  def stripAudio(movie)
    
    for visual in movie.visualSequence.visuals
      if visual.audio?
        audio = Audio.new(visual.file, visual.startPoint, visual.endPoint, visual.place, visual.volumePoints)
        movie.audioSequence.addAudio(audio)
      end
    end
  end
  
  #Searches overlapping visuals and merges them
  def mergeVisuals(movie)
    sortedVisuals = movie.visualSequence.sort
    overlapped = 0
    0.upto(sortedVisuals.length - 1) { |i|  
      unless i == (sortedVisuals.length - 1)
        clipA = sortedVisuals[i]
        clipB = sortedVisuals[i + 1]
        if clipA.inRange?(clipB.place.milliseconds)
          deltaX = (clipA.place.milliseconds + clipA.length) - clipB.place.milliseconds
          unless deltaX == 0
            clipB.startPoint.milliseconds=(clipB.startPoint.milliseconds + deltaX)
            clipB.place.milliseconds=(clipB.place.milliseconds + deltaX)
            overlapped += 1
          end          
        end        
      end
    }
    movie.visualSequence.visuals=(sortedVisuals)
    return overlapped
  end
  
  #Searches for gaps between videoclips and fills them with black screen
  def fillGaps(movie)
    sortedVisuals = movie.visualSequence.sort
    gaps = 0
    #Iterate through visuals and determine gaps => 
    #add generated blackness to fill in the gaps
    0.upto(sortedVisuals.length - 1) { |i|  
      unless i == (sortedVisuals.length - 1)
        clipA = sortedVisuals[i]
        clipB = sortedVisuals[i + 1]

        deltaX = clipB.place.milliseconds - (clipA.place.milliseconds + clipA.length)
        unless deltaX == 0 or deltaX < 0 #ToDo!: Why there is even a possibility for negative values?
          gapPlace = "00:00:00:" + (clipA.place.milliseconds + clipA.length).to_s
          gapStart = "00:00:00:00"
          gapEnd = "00:00:00:" + deltaX.to_s
          
          gap = Visual.new("blackness", "nil", gapStart, gapEnd, gapPlace, true, [], [])
          sortedVisuals << gap
          gaps += 1
        end
      end
    }
    movie.visualSequence.visuals=(sortedVisuals)
    return gaps
  end
  
  #Adds a black screen to the end of videotrack
  def truncateEndOfVideoTrack(movie)
    sortedVisuals = movie.visualSequence.sort
    sortedAudios = movie.audioSequence.sort
    
    lastAudio = sortedAudios[sortedAudios.length - 1]
    lastVisual = sortedVisuals[sortedVisuals.length - 1]
    
    #The length of the missing clip
    deltaX = (lastAudio.place.milliseconds + lastAudio.length) - (lastVisual.place.milliseconds + lastVisual.length)
      
    gapPlace = (lastVisual.place.milliseconds + lastVisual.length)
    gapStart = 0
    gapEnd = deltaX
      
    gap = Visual.new("blackness", "nil", gapStart, gapEnd, gapPlace, true, [], [])
    sortedVisuals << gap
    
    movie.visualSequence.visuals=(sortedVisuals)
  end
  
  def viewVisuals(visuals)
    0.upto(visuals.length - 1){|i|
      puts "-----------------------"
      puts "start: #{visuals[i].startPoint.milliseconds}"
      puts "end: #{visuals[i].endPoint.milliseconds}"
      puts "type: #{visuals[i].type}"
      puts "-----------------------"
    }
  end  
  private :viewVisuals
  
end
