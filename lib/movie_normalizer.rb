#Name: MovieNormalizer
#Author: Kai Kousa
#Description: Contains all methods needed for the normalization of a videoproject.
require "observable"
include Observable

class MovieNormalizer
  def initialize
    
  end
  
  def normalize(movie)  
    update_all("MovieNormalizer", "Searching for overlapping visuals...")
    overlapped = merge_visuals(movie)
    
    update_all("MovieNormalizer", "...found and edited #{overlapped} overlapped visuals!")

    update_all("MovieNormalizer", "Searching for gaps...")
    
    gaps = fill_gaps(movie)
    
    update_all("MovieNormalizer", "...found and filled #{gaps} gaps!")
    
    if(movie.audioLongerThanVideo?)
      truncate_end_of_video_track(movie)
      update_all("MovieNormalizer", "Audiotrack is longer than the videotrack! Added black screen to the end of videotrack.")
    end
    
    strip_audio(movie)
    
    #viewVisuals(movie.visualSequence.visuals)
    
    return movie
  end
  
  #Create Audio-objects from Visuals that have audiotracks and adds them to the movie
  def strip_audio(movie)
    
    for visual in movie.visual_sequence.visuals
      if visual.audio?
        audio = Audio.new(visual.file, visual.start_point, visual.end_point, visual.place, visual.volume_points)
        movie.audio_sequence.add_audio(audio)
      end
    end
  end
  
  #Searches overlapping visuals and merges them
  def merge_visuals(movie)
    sorted_visuals = movie.visual_sequence.sort
    overlapped = 0
    0.upto(sorted_visuals.length - 1) { |i|
      unless i == (sorted_visuals.length - 1)
        clip_a = sorted_visuals[i]
        clip_b = sorted_visuals[i + 1]
        if clip_a.in_range?(clip_b.place.milliseconds)
          delta_x = (clip_a.place.milliseconds + clip_a.length) - clip_b.place.milliseconds
          unless delta_x == 0
            clip_b.start_point.milliseconds = (clip_b.start_point.milliseconds + delta_x)
            clip_b.place.milliseconds = (clip_b.place.milliseconds + delta_x)
            overlapped += 1
          end          
        end        
      end
    }
    movie.visualSequence.visuals = sorted_visuals
    return overlapped
  end
  
  #Searches for gaps between videoclips and fills them with black screen
  def fill_gaps(movie)
    sorted_visuals = movie.visual_sequence.sort
    gaps = 0
    #Iterate through visuals and determine gaps => 
    #add generated blackness to fill in the gaps
    0.upto(sorted_visuals.length - 1) { |i|
      unless i == (sorted_visuals.length - 1)
        clip_a = sorted_visuals[i]
        clip_b = sorted_visuals[i + 1]

        delta_x = clip_b.place.milliseconds - (clip_a.place.milliseconds + clip_a.length)
        unless delta_x == 0 or delta_x < 0 #ToDo!: Why there is even a possibility for negative values?
          gap_place = "00:00:00:" + (clip_a.place.milliseconds + clip_a.length).to_s
          gap_start = "00:00:00:00"
          gap_end = "00:00:00:" + delta_x.to_s
          
          gap = Visual.new("blackness", "nil", gap_start, gap_end, gap_place, true, [], [])
          sorted_visuals << gap
          gaps += 1
        end
      end
    }
    movie.visualSequence.visuals = sorted_visuals
    return gaps
  end
  
  #Adds a black screen to the end of videotrack
  def truncate_end_of_video_track(movie)
    sorted_visuals = movie.visual_sequence.sort
    sorted_audios = movie.audio_sequence.sort
    
    last_audio = sorted_audios[sorted_audios.length - 1]
    last_visual = sorted_visuals[sorted_visuals.length - 1]
    
    #The length of the missing clip
    delta_x = (last_audio.place.milliseconds + last_audio.length) - (last_visual.place.milliseconds + last_visual.length)
      
    gap_place = (last_visual.place.milliseconds + last_visual.length)
    gap_start = 0
    gap_end = delta_x
      
    gap = Visual.new("blackness", "nil", gap_start, gap_end, gap_place, true, [], [])
    sorted_visuals << gap
    
    movie.visualSequence.visuals = sorted_visuals
  end
  
  def view_visuals(visuals)
    0.upto(visuals.length - 1){|i|
      puts "-----------------------"
      puts "file: #{visuals[i].file}"
      puts "start: #{visuals[i].start_point.milliseconds}"
      puts "end: #{visuals[i].end_point.milliseconds}"
      puts "type: #{visuals[i].type}"
      puts "-----------------------"
    }
  end  
  private :view_visuals
  
end
