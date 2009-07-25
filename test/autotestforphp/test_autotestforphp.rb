require File.dirname(__FILE__) + '/../test_helper.rb'

# NOT TESTED:
# add_sigint_handler
# notify
# reset
# run

class TestAutotestforphp < Test::Unit::TestCase

  def setup
    @atp = Autotestforphp.new
    @atp.base_path = File.dirname(__FILE__) + '/'
  end

  def teardown
    File.delete(File.dirname(__FILE__) + '/sample.php') if File.exist?(File.dirname(__FILE__) + '/sample.php')
    File.delete(File.dirname(__FILE__) + '/sample2.php') if File.exist?(File.dirname(__FILE__) + '/sample2.php')
    File.delete(@atp.bootstrap_file_path) if File.exist?(@atp.bootstrap_file_path)
    File.delete(@atp.phpunit_config_file_path) if File.exist?(@atp.phpunit_config_file_path)
    File.delete(@atp.config_file_path) if File.exist?(@atp.config_file_path)
    Dir.delete("#{@atp.base_path}autotestforphp/") if File.exist?("#{@atp.base_path}autotestforphp/")
  end

  def test_detect_file_change
    create_file('sample.php')
    create_file('sample2.php')
    
    @atp.watch(File.dirname(__FILE__) + '/sample*')
    assert !@atp.files_have_changed

    sleep 1
    touch_file('sample2.php')

    assert @atp.files_have_changed
    @atp.last_mtime = Time.now

    sleep 1
    assert !@atp.files_have_changed
  end

  def test_make_test_cmd_linux
    @atp.class.const_set :RUBY_PLATFORM, 'linux'
    assert_equal "phpunit --configuration \"#{@atp.phpunit_config_file_path}\"", @atp.make_test_cmd
  end

  def test_make_test_cmd_windows
    @atp.class.const_set :RUBY_PLATFORM, 'mswin'
    assert_equal "phpunit.bat --configuration \"#{@atp.phpunit_config_file_path}\"", @atp.make_test_cmd
  end

  def test_install
    @atp.install

    assert @atp.phpunit_config_file_exists?
    assert @atp.bootstrap_file_exists?
    assert @atp.config_file_exists?
  end

#  def test_make_test_cmd_mac
#
#  end

private
  def create_file(file_name)
    File.new("#{File.dirname(__FILE__)}/#{file_name}", 'w').close
  end
  def touch_file(file_name)
    File.open("#{File.dirname(__FILE__)}/#{file_name}", 'w') do |f|
      f.puts 'test'
    end
  end
end
