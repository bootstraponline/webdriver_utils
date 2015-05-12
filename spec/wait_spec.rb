require_relative 'spec_helper'

# appium wait tests
# https://github.com/appium/ruby_lib/blob/252e83806318df7df28e9060d3f8e1e56dc732ba/ios_tests/lib/ios/specs/common/helper.rb

describe 'appium wait' do

  wait_opts = { timeout: 0.2, interval: 0.2 } # max_wait, interval

# There's no `must_not_raise` as the opposite of to raise_error

# By default code is expected to not raise exceptions.
# must_not_raise is a no-op.

# wait is a success unless an error is raised
# max_wait=0 is infinity. to wait a short amount use 0.1
  it 'wait' do
    # successful wait should not raise error
    wait(wait_opts) { true }
    wait(wait_opts) { false }
    wait(wait_opts) { nil }
    wait(3) { nil }

    # failed wait should error
    expect { wait(wait_opts) { fail } }.to raise_error Selenium::WebDriver::Error::TimeOutError
    expect { wait(0.1) { fail } }.to raise_error Selenium::WebDriver::Error::TimeOutError

    # regular rescue will not handle exceptions outside of StandardError hierarchy
    # must rescue Exception explicitly to rescue everything
    expect { wait(wait_opts) { fail NoMemoryError } }.to raise_error Selenium::WebDriver::Error::TimeOutError
    expect { wait(timeout: 0.2, interval: 0.0) { fail NoMemoryError } }.to raise_error Selenium::WebDriver::Error::TimeOutError

    # invalid keys are rejected
    expect { wait(invalidkey: 2) { true } }.to raise_error RuntimeError
  end

  it 'ignore' do
    # ignore should rescue all exceptions
    ignore { true }
    ignore { false }
    ignore { nil }
    ignore { fail }
    ignore { fail NoMemoryError }
  end

# wait_true is a success unless the value is not true
  it 'wait_true' do
    # successful wait should not error
    wait_true(wait_opts) { true }

    # failed wait should error
    expect { wait_true(wait_opts) { false } }.to raise_error Selenium::WebDriver::Error::TimeOutError
    expect { wait_true(wait_opts) { nil } }.to raise_error Selenium::WebDriver::Error::TimeOutError

    # raise should error
    expect { wait_true(wait_opts) { fail } }.to raise_error Selenium::WebDriver::Error::TimeOutError

    # regular rescue will not handle exceptions outside of StandardError hierarchy
    # must rescue Exception explicitly to rescue everything
    expect { wait_true(wait_opts) { fail NoMemoryError } }.to raise_error Selenium::WebDriver::Error::TimeOutError
    expect { wait_true(timeout: 0.2, interval: 0.0) { fail NoMemoryError } }
      .to raise_error Selenium::WebDriver::Error::TimeOutError

    # invalid keys are rejected
    expect { wait_true(invalidkey: 2) { true } }.to raise_error RuntimeError
  end
end
