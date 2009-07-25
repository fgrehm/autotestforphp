require File.dirname(__FILE__) + '/test_helper.rb'

class TestResult < Test::Unit::TestCase
  include REXML

  def test_can_parse_xml
    verify_results(10, 4, 2, 1)
    verify_results(10, 0, 0, 0)
    verify_results(10, 2, 3, 1)
    verify_results(100, 200, 22, 51)
  end

  def test_message
    verify_message(100, 200, 1, 0)
    verify_message(12, 22, 1, 7)
    verify_message(13, 5, 0, 3)
  end

  def test_image_when_all_passed
    result = create_result(100, 100, 0, 0)

    assert_equal(Autotestforphp::Notification::Config.success_image, result.image)
  end

  def test_image_when_failed
#    result = create_result(100, 100, 0, 0)
#
#    assert_equal(Autotestforphp::Notification::Config.success_image)
  end

private

  def create_result(num_tests, num_assertions, num_errors, num_failures)
    xml = build_xml(num_tests, num_assertions, num_errors, num_failures)
    Autotestforphp::Result.build_from_xml(xml)
  end

  def verify_message(num_tests, num_assertions, num_errors, num_failures)
    result = create_result(num_tests, num_assertions, num_errors, num_failures)

    assert_equal("#{num_tests} tests, #{num_assertions} assertions, #{num_failures} failures, #{num_errors} errors", result.message)
  end

  def verify_results(num_tests, num_assertions, num_errors, num_failures)
    result = create_result(num_tests, num_assertions, num_errors, num_failures)

    assert_equal(num_tests, result.num_tests)
    assert_equal(num_assertions, result.num_assertions)
    assert_equal(num_errors, result.num_errors)
    assert_equal(num_failures, result.num_failures)
  end

  def build_xml(num_tests, num_assertions, num_errors, num_failures)
    <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuites>
  <testsuite name="FailureErrorTest" file="/home/sb/FailureErrorTest.php" tests="#{num_tests}" assertions="#{num_assertions}" failures="#{num_failures}" errors="#{num_errors}" time="0.019744">
    <testcase name="testFailure" class="FailureErrorTest" file="/home/sb/FailureErrorTest.php" line="6" assertions="1" time="0.011456">
      <failure type="PHPUnit_Framework_ExpectationFailedException">
failure description
</failure>
    </testcase>
    <testcase name="testError" class="FailureErrorTest" file="/home/sb/FailureErrorTest.php" line="11" assertions="0" time="0.008288">
      <error type="Exception">testError(FailureErrorTest)
exception description
</error>
    </testcase>
  </testsuite>
</testsuites>
EOF
  end
end
