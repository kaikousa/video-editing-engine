require "vre"

puts "\nVideo Rendering Engine (v.0.1-alpha)"
puts ""

xmlFile = ARGV[0]
if(xmlFile == nil)
  puts "Parameter missing!"
  puts "USAGE: ruby vre_runner <xmlfile>"
  puts ""
else
  start = Time.now

  vre = Vre.new()
  vre.main(xmlFile)

  stop = Time.now
  puts "It took #{stop - start} seconds to finish"
end