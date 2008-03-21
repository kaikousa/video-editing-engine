# Name: TestTimeCode
# Author: Kai Kousa
# Description: Test cases for TimeCode-class
require "tools/time_code"
require 'test/unit'

class TestTimeCode < Test::Unit::TestCase
  
  def testConvertToMs
    time = TimeCode.new("03:04:20:30")
    assert_equal(11060030, time.milliseconds)
  end
  
  def testPlus
    a = TimeCode.new("00:00:00:30")
    b = TimeCode.new("00:00:00:20")
    assert_equal("0:0:0:50", (a + b).timeCodeStr)
  end
  
  def testPlusBigTime
    a = TimeCode.new("03:04:20:30")
    b = TimeCode.new("01:02:10:20")
    assert_equal("4:6:30:50", (a + b).timeCodeStr)
  end
  
  def testMinus
    a = TimeCode.new("0:0:0:30")
    b = TimeCode.new("0:0:0:20")
    assert_equal("0:0:0:10", (a - b).timeCodeStr)
  end
  
  def testMinusBigTime
    a = TimeCode.new("03:04:20:30")
    b = TimeCode.new("01:02:10:20")
    assert_equal("2:2:10:10", (a - b).timeCodeStr)
  end
  
end
