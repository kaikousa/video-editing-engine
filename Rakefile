# Name: Rakefile
# Author: Kai Kousa
# Description: Tasks to package and test Video Rendering Engine. 

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
$: << "lib"

task :test do 
  require 'rake/runtest'
  Rake.run_tests 'test/**/test_*.rb'
end