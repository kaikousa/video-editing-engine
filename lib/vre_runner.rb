require "vre"
start = Time.now

xmlFile = ARGV[0]
vre = Vre.new()
vre.main(xmlFile)

stop = Time.now
puts "It took #{stop - start} seconds to finish"
