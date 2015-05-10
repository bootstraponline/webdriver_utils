# https://github.com/SeleniumHQ/selenium/blob/b12ff650686cd88a0709f6181a015dad1062591e/rb/lib/selenium/webdriver/common/wait.rb
#
# Licensed to the Software Freedom Conservancy (SFC) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The SFC licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module WebDriverUtils
  class Wait

    DEFAULT_TIMEOUT  = 5
    DEFAULT_INTERVAL = 0.2

    #
    # Create a new Wait instance
    #
    # @param [Hash] opts Options for this instance
    # @option opts [Numeric] :timeout (5) Seconds to wait before timing out.
    # @option opts [Numeric] :interval (0.2) Seconds to sleep between polls.
    # @option opts [String] :message Exception mesage if timed out.
    # @option opts [Array, Exception] :ignore Exceptions to ignore while polling (default: Error::NoSuchElementError)
    #

    def initialize(opts = {})
      # Validate all options to prevent typos such as 'ignored'
      # instead of 'ignore'

      # code from my appium gem
      # https://github.com/appium/ruby_lib/blob/252e83806318df7df28e9060d3f8e1e56dc732ba/lib/appium_lib/common/wait.rb#L10
      valid_keys   = [:timeout, :interval, :message, :ignore]
      invalid_keys = []
      opts.keys.each { |key| invalid_keys << key unless valid_keys.include?(key) }
      # [:one, :two] => :one, :two
      fail "Invalid keys #{invalid_keys.to_s[1..-2]}. Valid keys are #{valid_keys.to_s[1..-2]}" unless invalid_keys.empty?

      @timeout  = opts.fetch(:timeout, DEFAULT_TIMEOUT)
      @interval = opts.fetch(:interval, DEFAULT_INTERVAL)
      @message  = opts[:message]
      @ignored  = Array(opts[:ignore] || ::Selenium::WebDriver::Error::NoSuchElementError)
    end

    #
    # Wait until the given block returns a true value.
    #
    # @raise [Error::TimeOutError]
    # @return [Object] the result of the block
    #

    def until(&blk)
      end_time   = Time.now + @timeout
      last_error = nil

      until Time.now > end_time
        begin
          result = yield
          return result if result
        rescue *@ignored => last_error
          # swallowed
        end

        sleep @interval
      end


      if @message
        msg = @message.dup
      else
        msg = "timed out after #{@timeout} seconds"
      end

      msg << " (#{last_error.message})" if last_error

      raise ::Selenium::WebDriver::Error::TimeOutError, msg
    end

  end # class Wait
end # module WebDriverUtils

#
# Define generic top level wait method
#
# Wait until the block returns a truthy value.
#
# See wait class above for docs
#

def wait opts={}, &block
  timeout        = opts.fetch(:timeout, 30)
  interval       = opts.fetch(:interval, 0.2)
  message        = opts[:message]
  ignored        = Array(opts[:ignore])
  default_ignore = [Exception, RSpec::Expectations::ExpectationNotMetError]
  ignored        = default_ignore if ignored.empty?

  WebDriverUtils::Wait.new(timeout:  timeout,
                           interval: interval,
                           message:  message,
                           ignore:   ignored).until &block
end
