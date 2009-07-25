require File.dirname(__FILE__) + '/test_helper.rb'

class TestNotification < Test::Unit::TestCase

  def setup
    @title = "title"
    @msg = "message"
    @image = "image"
  end

  def test_notify_when_os_is_windows
    notifier = Autotestforphp::Notification::Windows
    notifier.expects(:notify).with(@title, @msg, @image)
    verify_to("mswin")
  end

  def test_notify_when_os_is_linux
    notifier = Autotestforphp::Notification::Linux
    notifier.expects(:notify).with(@title, @msg, @image)
    verify_to("linux")
  end

  def test_notify_when_os_is_mac
    notifier = Autotestforphp::Notification::Mac
    notifier.expects(:notify).with(@title, @msg, @image)
    verify_to("darwin")
  end

private

  def verify_to(so)
    Autotestforphp::Notification.const_set :RUBY_PLATFORM, so
    Autotestforphp::Notification.notify(@title, @msg, @image)
  end
end