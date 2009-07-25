require 'snarl' if RUBY_PLATFORM =~ /mswin/

class Autotestforphp
  module Notification
    module Windows
      class << self
        def notify(title, msg, img)
          Snarl.show_message(title, msg, img)
        end
      end
    end
  end
end