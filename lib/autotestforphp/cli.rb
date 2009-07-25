require 'optparse'

class Autotestforphp
  class CLI
    def self.execute(stdout, arguments=['--run'])
      arguments = ['--run'] unless arguments.size > 0 # defaults to run

      OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          Usage: #{File.basename($0)} [options]

          Options are:
BANNER

        opts.separator("")

        opts.on('-i', '--install',
          'Install AutotestForPHP') do
          Autotestforphp.install
          stdout.puts 'Autotest for PHP was installed successfully'
        end

        opts.on('-r', '--run',
          'Run AutotestForPHP (default)') do
          config_file = File.expand_path('./autotestforphp/config.autotest')
          load config_file if File.exist?(config_file)

          unless defined?(FOLDERS_TO_WATCH)
            folders = ["./src/**/*", "./test/**/*", "./app/**/*", "./lib/**/*"]
          else
            folders = FOLDERS_TO_WATCH
          end
          Autotestforphp.run(folders)
        end

        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }

        opts.parse!(arguments)
      end
    end
  end
end