$: << "lib"
require "vee"
#This section is for launching the VRE on the command line.

puts "\nVideo Editing Engine (v.0.2-alpha)"
puts ""

movie_file = ARGV[0]
if(movie_file == nil)
  puts "Parameter missing!"
  puts "USAGE: ruby vre <file>"
  puts ""
  puts "Video Editing Engine supports movies in the following formats:"
  puts "\t- XML (channeled or sequenced)"
  puts "\t- JSON"
  puts "See the documentation for detailed instructions on creating project files"
  puts ""
else
  start = Time.now

  vee = Vee.new()
  vee.process_movie_file(movie_file)

  stop = Time.now
  puts "It took #{stop - start} seconds to finish"
end
