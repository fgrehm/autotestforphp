require File.dirname(__FILE__) + '/test_helper.rb'

class TestLinux < Test::Unit::TestCase

  def setup
    @notifier = Autotestforphp::Notification::Linux
  end

  def test_notify_when_use_notify
    @notifier.expects(:has_notify?).returns(true)
    verify_notify(:notify_send)
  end

  def test_notify_when_use_zenity
    @notifier.expects(:has_notify?).returns(false)
    @notifier.expects(:has_zenity?).returns(true)
    verify_notify(:zenity)
  end

  def test_notify_when_use_kdialog
    @notifier.expects(:has_notify?).returns(false)
    @notifier.expects(:has_zenity?).returns(false)
    @notifier.expects(:has_kdialog?).returns(true)
    verify_notify(:kdialog)
  end

  def test_notify_send
    @notifier.expects(:system).with('notify-send -i image \'title\' \'msg\'')
    @notifier.notify_send("title", "msg", "image")
  end

  def test_notify_kdialog
    @notifier.expects(:system).with('kdialog --title \'title\' --passivepopup \'<img src="image" align="middle"> msg\'')
    @notifier.kdialog("title", "msg", "image")
  end

  def test_notify_zenity
    @notifier.expects(:system).with('zenity --info --text=\'msg\' --title=\'title\'')
    @notifier.zenity("title", "msg", "image")
  end

  def test_has_zenity?
    @notifier.expects(:system).with('which zenity > /dev/null 2>&1')
    @notifier.has_zenity?
  end

  def test_has_notify?
    @notifier.expects(:system).with('which notify-send > /dev/null 2>&1')
    @notifier.has_notify?
  end

  def test_has_kdialog?
    @notifier.expects(:system).with('which kdialog > /dev/null 2>&1')
    @notifier.has_kdialog?
  end

  private

  def verify_notify(method)
    @notifier.expects(method).returns("title", "msg", "image")
    @notifier.notify("title", "msg", "image")
  end
end