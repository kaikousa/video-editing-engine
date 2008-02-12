require 'movie_builder'
 

puts 'Creating an instance of the MovieBuilder'

builder = MovieBuilder.new
builder.buildMovie('movie-example.xml')
movie = builder.movie

puts movie.to_str

puts "Visuals length: #{movie.visualSequence.visuals.length}" 
puts "Audios length: #{movie.audioSequence.audios.length}"
puts "Effects length: #{movie.effects.length}"
puts movie.visualSequence.to_str

puts 'instance created. Goodbye!'
