require "rubygems"
require "json/pure"
require "model/movie"
require "model/audio_sequence"
require "model/visual_sequence"
require "model/visual"
require "model/audio"

class JSONBuilder
	def initialize()
    
	end
  
  def build_movie(json_file)
    data = File.open(json_file)
    data_str = ""
    data.each{|line| data_str += line}
    data.close()
    return build_movie_from_str(data_str)
  end
  
  def build_movie_from_str(json_str)
    project_data = JSON.parse(json_str)
    name = project_data["movie"]["name"]
    format = project_data["movie"]["format"]
    resolution = project_data["movie"]["resolution"]
    @movie = Movie.new(name, format, resolution)
    
    visual_sequence = VisualSequence.new
    
    project_data["video_timelines"].each{|timeline|
      timeline.each{|video_item|
        result = read_item(video_item)
        visual = Visual.new("video", video_item["filename"], result["start_point"], result["end_point"], result["place"], false, [], []) 
        visual_sequence.add_video(visual)
      }
    }
    @movie.visual_sequence = visual_sequence
    
    audio_sequence = AudioSequence.new
    
    project_data["audio_timelines"].each{|timeline|
      timeline.each{|audio_item|
        result = read_item(audio_item)
        audio = Audio.new(audio_item["filename"], result["start_point"], result["end_point"], result["place"], [])
        audio_sequence.add_audio(audio)
      }
    }
    @movie.audio_sequence = audio_sequence
    
    return @movie
  end
  
  def read_item(item)
    in_h = item["in_h"]
    in_m = item["in_m"]
    in_s = item["in_s"]
    in_ms = item["in_ms"]
    start_point = create_timecode(in_h, in_m, in_s, in_ms)
    
    out_h = item["out_h"]
    out_m = item["out_m"]
    out_s = item["out_s"]
    out_ms = item["out_ms"]
    end_point = create_timecode(out_h, out_m, out_s, out_ms)
    
    place_h = item["offset_h"]
    place_m = item["offset_m"]
    place_s = item["offset_s"]
    place_ms = item["offset_ms"]
    place = create_timecode(place_h, place_m, place_s, place_ms)
    
    return { "start_point" => start_point, "end_point" => end_point, "place" => place }
  end
  
  def create_timecode(hour, minute, second, millisecond)
    return hour.to_s + ":" + minute.to_s + ":" + second.to_s + ":" + millisecond.to_s
  end
  private :create_timecode
  
end
