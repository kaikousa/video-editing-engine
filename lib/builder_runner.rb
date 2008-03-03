require "vre"
start = Time.now
vre = Vre.new()
vre.main()
stop = Time.now
puts "It took #{stop - start} seconds to finish"
