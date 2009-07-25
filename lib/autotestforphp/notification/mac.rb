require 'snarl' if RUBY_PLATFORM =~ /mswin/

class Autotestforphp
  module Notification
    module Mac
      @last_test_failed = false

      class << self

        def notify(title, msg, img)
          system "growlnotify -n autotest --image #{img} -m '#{msg}' -t #{title}"
        end
      end
    end
  end
end