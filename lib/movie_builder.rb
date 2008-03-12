#Name: MovieBuilder 
#Author: Kai Kousa
#Description: MovieBuilder takes in an xml-file and creates an object model
#of the movie. This model is then processed so that we end up with separate
# audio and videosequences.
require "rexml/document"
include REXML
require "model/movie"
require "model/effect"
require "channeled_builder"
require "sequenced_builder"
require "observable"
include Observable

class MovieBuilder
  
  attr_reader(:movie)
  
  def initialize
    
  end
  
  #Builds the object model from the given xml-file
  #ToDo: Validate xml
  def buildMovie(xmlFile)
    updateAll("MovieBuilder", "Reading the object model from xml(#{xmlFile})...")
    xml = Document.new(File.open(xmlFile))
    
    e = XPath.first(xml, "movie")
    timelineFormat = e.attribute("type").to_s #Get the attribute and convert to string
    fileVersion = e.attribute("version")
    
    #updateAll("Filetype: #{fileType} Version: #{fileVersion}")
    
    name = XPath.first(xml, "//metadata/name").text
    format = XPath.first(xml, "//metadata/format").text
    resolution = XPath.first(xml, "//metadata/resolution").text
    
    @movie = Movie.new(name, format, resolution)
    
    if(timelineFormat == "channeled")
      updateAll("MovieBuilder", "Building an object model from channeled timeline-format...")
      channeledBuilder = ChanneledBuilder.new
      @movie = channeledBuilder.buildMovie(xml, @movie)
    elsif(timelineFormat == "sequenced")
      updateAll("MovieBuilder", "Building an object model from sequenced timeline-format...")
      sequencedBuilder = SequencedBuilder.new
      @movie = sequencedBuilder.buildMovie(xml, @movie)
    else
      updateAll("MovieBuilder", "Unknown timeline-format(#{timelineFormat})")
    end
    
    updateAll("MovieBuilder", "...object model finished!")
    
    updateAll("MovieBuilder", "Beginning normalization...")
    normalize()
    updateAll("MovieBuilder", "Normalization finished!")
    
    return @movie
  end
  
  def normalize()
    #Create Audio-objects from Visuals that have audiotracks
    for visual in @movie.visualSequence.visuals
      if visual.audio?
        audio = Audio.new(visual.file, visual.startPoint.timeCodeStr, visual.endPoint.timeCodeStr, visual.place.timeCodeStr, visual.volumePoints)
        @movie.audioSequence.addAudio(audio)
      end
    end
    
    #Sort visuals by place(in the timeline)
    sortedVisuals = @movie.visualSequence.visuals.sort{|x, y| x.place.milliseconds <=> y.place.milliseconds}
    
      #sortedVisuals.each{ |vis| puts "StartPoint:" + vis.place }
    
      #@movie.visualSequence.replaceVisuals(sortedVisuals)
    updateAll("MovieBuilder", "Searching for overlapping visuals...")
    overlapped = 0
    edited = 0
    #puts "length: #{sortedVisuals.length}"
    #Iterate through sorted visuals and determine overlapping visuals => cut
    0.upto(sortedVisuals.length - 1) { |i|  
      unless i == (sortedVisuals.length - 1)
        #puts i
        clipA = sortedVisuals[i]
        clipB = sortedVisuals[i + 1]
        if clipA.inRange?(clipB.place.milliseconds)
          deltaX = (clipA.place.milliseconds + clipA.length) - clipB.place.milliseconds
          unless deltaX == 0
            clipB.startPoint.milliseconds=(clipB.startPoint.milliseconds + deltaX)
            clipB.place.milliseconds=(clipB.place.milliseconds + deltaX)
            edited += 1
          end
          overlapped += 1
        end        
      end
    }
    
    updateAll("MovieBuilder", "Found #{overlapped} overlapped visuals and edited #{edited} of them.")

    updateAll("MovieBuilder", "Searching for gaps...")
    gaps = 0
    #puts "length: #{sortedVisuals.length}"
    #Iterate through sorted and cutted visuals and determine gaps => 
    #add generated blackness to fill in the gaps
    0.upto(sortedVisuals.length - 1) { |i|  
      unless i == (sortedVisuals.length - 1)
        #puts i
        clipA = sortedVisuals[i]
        clipB = sortedVisuals[i + 1]

        deltaX = clipB.place.milliseconds - (clipA.place.milliseconds + clipA.length)
        unless deltaX == 0 or deltaX < 0 #ToDo!: Why there is even a possibility for negative values?
          #puts "found a gap! length: #{deltaX} clipId: #{i}"
          gapPlace = "00:00:00:" + (clipA.place.milliseconds + clipA.length).to_s
          gapStart = "00:00:00:00"
          gapEnd = "00:00:00:" + deltaX.to_s
          
          gap = Visual.new("blackness", "nil", gapStart, gapEnd, gapPlace, true, [], [])
          sortedVisuals << gap
          gaps += 1
        end
      end
    }
    updateAll("MovieBuilder", "Found and filled #{gaps} gaps!")    
    
    #sort visuals again, so that the added clips fall into right places
    sortedVisuals = sortedVisuals.sort{|x, y| x.place.milliseconds <=> y.place.milliseconds}
    
    sortedAudios = @movie.audioSequence.audios.sort{|x, y| x.place.milliseconds <=> y.place.milliseconds}
    lastAudio = sortedAudios[sortedAudios.length - 1]
    lastVisual = sortedVisuals[sortedVisuals.length - 1]
    if (lastAudio.place.milliseconds + lastAudio.length) > (lastVisual.place.milliseconds + lastVisual.length)
      deltaX = (lastAudio.place.milliseconds + lastAudio.length) - (lastVisual.place.milliseconds + lastVisual.length)
      
      gapPlace = "00:00:00:" + (lastVisual.place.milliseconds + lastVisual.length).to_s
      gapStart = "00:00:00:00"
      gapEnd = "00:00:00:"+deltaX.to_s
      
      gap = Visual.new("blackness", "nil", gapStart, gapEnd, gapPlace, true, [], [])
      sortedVisuals << gap
      updateAll("MovieBuilder", "Audiotrack is longer than the videotrack! Added black screen to the end of videotrack.")
    end

    @movie.visualSequence.visuals=(sortedVisuals)
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
