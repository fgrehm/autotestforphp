require File.dirname(__FILE__) + '/test_helper.rb'

class TestMac < Test::Unit::TestCase

  def setup
    @notifier = Autotestforphp::Notification::Mac
    @notifier.stubs(:system)
  end

  def test_notify
    @notifier.expects(:system).with("growlnotify -n autotest --image image -m 'msg' -t title")
    @notifier.notify("title", "msg", "image")
  end
end