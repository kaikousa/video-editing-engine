# Name: TestTimeCode
# Author: Kai Kousa
# Description: Test cases for TimeCode-class
require "../lib/tools/time_code"
require 'test/unit'

class TestTimeCode < Test::Unit::TestCase
  
  def testConvertToMs
    time = TimeCode.new("03:04:20:30")
    assert_equal(11060030, time.convertToMs())
  end
  
end
