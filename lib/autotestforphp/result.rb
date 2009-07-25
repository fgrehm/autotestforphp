class Autotestforphp
  class Result
    include REXML

    attr_reader(:num_tests,
                :num_assertions,
                :num_errors,
                :num_failures)

    def initialize(num_tests, num_assertions, num_errors, num_failures)
      @num_tests = num_tests
      @num_assertions = num_assertions
      @num_errors = num_errors
      @num_failures = num_failures
    end

    def message
      "#{num_tests} tests, #{num_assertions} assertions, #{num_failures} failures, #{num_errors} errors"
    end

    def image
      config = Autotestforphp::Notification::Config
      if num_failures == 0 and num_errors == 0
        config.success_image
      else
        config.fail_image
      end
    end

    def self.build_from_xml(xml)
      unless xml.is_a?(Document)
        xml = Document.new(xml)
      end
      results = XPath.first(xml, '//testsuite')
      num_tests = results.attributes["tests"].to_i
      num_failures = results.attributes["failures"].to_i
      num_errors = results.attributes["errors"].to_i
      num_assertions = results.attributes["assertions"].to_i
      new(num_tests, num_assertions, num_errors, num_failures)
    end
  end
end