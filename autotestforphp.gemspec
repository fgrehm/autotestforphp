Gem::Specification.new do |s|
  s.name = %q{autotestforphp}
  s.version = "0.0.2"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["F\303\241bio Rehm"]
  s.date = %q{2009-07-24}
  s.default_executable = %q{autotestforphp}
  s.description = %q{Autotest tool for PHP}
  s.email = ["fgrehm@gmail.com"]
  s.executables = ["autotestforphp"]
  s.homepage = %q{http://github.com/fgrehm/autotestforphp}
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "autotestforphp.gemspec", "bin/autotestforphp", "images/fail.png", "images/pass.png", "lib/autotestforphp.rb", "lib/autotestforphp/cli.rb", "lib/autotestforphp/notification.rb", "lib/autotestforphp/notification/linux.rb", "lib/autotestforphp/notification/mac.rb", "lib/autotestforphp/notification/windows.rb", "lib/autotestforphp/result.rb", "script/console", "script/destroy", "script/generate", "test/autotestforphp/test_autotestforphp.rb", "test/cli/test_autotestforphp_cli.rb", "test/test_helper.rb", "test/test_linux.rb", "test/test_mac.rb", "test/test_notification.rb", "test/test_result.rb", "test/test_windows.rb"]
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{autotestforphp}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Autotest tool for PHP}
  s.test_files = ["test/cli/test_autotestforphp_cli.rb", "test/test_linux.rb", "test/test_notification.rb", "test/test_helper.rb", "test/test_windows.rb", "test/test_result.rb", "test/test_mac.rb", "test/autotestforphp/test_autotestforphp.rb"]

  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 2.3.2"])
    else
      s.add_dependency(%q<hoe>, [">= 2.3.2"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 2.3.2"])
  end
end
