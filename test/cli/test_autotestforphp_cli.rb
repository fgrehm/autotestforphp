require File.join(File.dirname(__FILE__), '..', "test_helper.rb")
require 'autotestforphp/cli'
require 'mocha'

class TestAutotestforphpCli < Test::Unit::TestCase
  def setup
    @atp = Autotestforphp
  end

  def test_default_folders_to_watch
    @atp.expects(:run).
      with(["./src/**/*", "./test/**/*", "./app/**/*", "./lib/**/*"]).
      once

    execute
  end

  def test_loads_folders_from_config
    @atp.const_set :FOLDERS_TO_WATCH, ["./src/**/*"]
    @atp.expects(:run).
      with(["./src/**/*"]).
      once
    
    execute
  end

  def test_print_message_after_installation
    Autotestforphp.expects(:install).
                   once

    execute(['--install'])

    assert_match(/Autotest for PHP was installed successfully/, @stdout)
  end
  private

  def execute(args = [])
    Autotestforphp::CLI.execute(@stdout_io = StringIO.new, args)
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
end