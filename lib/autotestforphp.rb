$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'date'
require 'rexml/document'
require 'autotestforphp/notification'
require 'autotestforphp/result'

class Autotestforphp
  VERSION = '0.0.3'

  class << self
    def install
      new.install
    end
    def run(folders_to_watch)
      folders_to_watch.map!{ |folder| File.expand_path(folder) }
      atp = new
      atp.watch(folders_to_watch)
      atp.run
    end
  end

  attr_accessor(:files_to_watch,
    :filters,
    :interrupted,
    :last_mtime,
    :tainted,
    :wants_to_quit)

  def initialize
    #    reset
    self.files_to_watch = []
  end

  def base_path=(path)
    @base_path = path
  end
  def base_path
    if @base_path.nil?
      self.base_path = File.expand_path('./') + "/"
    end
    @base_path
  end
  def config_file_path
    "#{base_path}autotestforphp/config.autotest"
  end
  def phpunit_log_file_path
    "#{base_path}autotestforphp/logfile.xml"
  end
  def phpunit_config_file_path
    "#{base_path}autotestforphp/phpunit-autotest.xml"
  end
  def bootstrap_file_path
    "#{base_path}autotestforphp/bootstrap-autotest.php"
  end

  def phpunit_config_file_exists?
    File.exist?(phpunit_config_file_path)
  end
  def bootstrap_file_exists?
    File.exist?(bootstrap_file_path)
  end
  def phpunit_log_file_exists?
    File.exist?(phpunit_log_file_path)
  end
  def config_file_exists?
    File.exist?(config_file_path)
  end

  def make_test_cmd
    case RUBY_PLATFORM
    when /linux/,/darwin/
      cmd = "phpunit"
    when /mswin/
      cmd = "phpunit.bat"
    else
      raise('Your OS not supported yet!')
    end
    "#{cmd} --configuration \"#{phpunit_config_file_path}\""
  end

  def install
    Dir.mkdir("#{base_path}autotestforphp/") unless File.exist?("#{base_path}autotestforphp/")
    File.open(phpunit_config_file_path, 'w') do |f|
      f.puts <<-CONFIG
<phpunit bootstrap="./autotestforphp/bootstrap-autotest.php">
    <testsuite name="Application">
        <directory>./test/</directory>
    </testsuite>
    <logging>
        <log type="junit" target="./autotestforphp/logfile.xml" />
        <!-- log type="test-xml" target="./autotestforphp/logfile.xml" for PHPUnit <= 3.2 /-->
    </logging>
</phpunit>
CONFIG
    end
    File.open(bootstrap_file_path, 'w').close
    File.open(config_file_path, 'w').close
  end

  def run
    add_sigint_handler

    loop do # ^c handler
      begin        
        run_all_tests
        wait_for_changes
      rescue Interrupt
        break if self.wants_to_quit
        reset
      end
    end
  end

  def run_all_tests
    cmd = make_test_cmd
    self.last_mtime = Time.now

    clear_log
    clear_screen
    puts cmd
    system(cmd)

    notify
  end
  def watch(folders)
    self.last_mtime = Time.now
    self.filters = folders
    folders.each do |arg|
      Dir[arg].each do |file|
        self.files_to_watch << file unless File.directory?(file)
      end
    end
  end
  def files_have_changed
    not self.files_to_watch.find { |f|
      File.exist?(f) and File.mtime(f) > self.last_mtime
    }.nil?
  end
  def add_sigint_handler
    trap 'INT' do
      if self.interrupted then
        self.wants_to_quit = true
      else
        puts "Interrupt a second time to quit"
        self.interrupted = true
        sleep 1.5
        raise Interrupt, nil # let the run loop catch it
      end
    end
  end
  def wait_for_changes
    sleep 1.5 until files_have_changed
  end
  def reset
    self.interrupted = false
    self.tainted = false
    self.wants_to_quit = false
    self.watch(self.filters)
  end

private

  def clear_log
    File.delete(phpunit_log_file_path) if phpunit_log_file_exists?
  end  
  def clear_screen
    case RUBY_PLATFORM
    when /linux/,/darwin/
      system("clear")
    when /mswin/
      system("cls")
    else
      raise('Your OS not supported yet!')
    end
  end
  def notify
    unless File.exist?(phpunit_log_file_path) and File.size(phpunit_log_file_path) > 0
      msg = 'Tests could not be executed'
      img = Notification::Config.fail_image
    else
      f = File.new(phpunit_log_file_path)
      result = Result.build_from_xml(f)
      f.close
      msg = result.message
      img = result.image
    end

    Notification.notify('Autotest for PHP', msg, img)
  end
end
