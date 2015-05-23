# wait code from my appium ruby gem:
# https://github.com/appium/ruby_lib/blob/252e83806318df7df28e9060d3f8e1e56dc732ba/lib/appium_lib/common/wait.rb
module WebDriverUtils
  class << self
    # http://mudge.name/2011/01/26/passing-blocks-in-ruby-without-block.html
    # Note that the Ruby timeout module is avoided. timeout has problems.
    # https://coderwall.com/p/1novga

    # bubble - if set, the last exception will be raised if it exists
    # Wait code from the selenium Ruby gem
    # https://github.com/SeleniumHQ/selenium/blob/cf501dda3f0ed12233de51ce8170c0e8090f0c20/rb/lib/selenium/webdriver/common/wait.rb
    def _generic_wait(opts = {}, &block)
      valid_keys   = [:timeout, :interval, :message, :ignore, :return_if_true, :bubble]
      invalid_keys = []
      opts.keys.each { |key| invalid_keys << key unless valid_keys.include?(key) }
      # [:one, :two] => :one, :two
      fail "Invalid keys #{invalid_keys.to_s[1..-2]}. Valid keys are #{valid_keys.to_s[1..-2]}" unless invalid_keys.empty?

      timeout        = opts.fetch(:timeout, 30)
      interval       = opts.fetch(:interval, 0.2)
      message        = opts[:message]
      ignored        = Array(opts[:ignore] || ::Exception)
      return_if_true = opts[:return_if_true]
      bubble         = !!opts.fetch(:bubble, false)

      start_time = Time.now
      end_time   = start_time + timeout
      last_error = nil

      until Time.now > end_time
        begin
          if return_if_true
            result = block.call
            return result if result
          else
            return block.call
          end
        rescue ::Errno::ECONNREFUSED, ::TypeError, ::NameError, ::NoMethodError => e
          raise e
        rescue *ignored => last_error # rubocop:disable Lint/HandleExceptions
          # swallowed
        end

        sleep interval
      end

      elapsed_time    = (Time.now - start_time).round
      default_message = "timed out after #{elapsed_time} seconds (timeout: #{timeout})"

      if message
        msg = "#{message.dup} [#{default_message}]"
      else
        msg = default_message
      end

      msg << " (#{last_error.message})" if last_error

      fail_error = last_error if bubble
      fail_error ||= Selenium::WebDriver::Error::TimeOutError

      fail fail_error, msg
    end

    # process opts before calling _generic_wait
    def _process_wait_opts(opts)
      opts = { timeout: opts } if opts.is_a?(Numeric)
      fail 'opts must be a hash' unless opts.is_a? Hash
      opts
    end
  end # class << self
end # module WebDriverUtils

# Check every interval seconds to see if block.call returns a truthy value.
# Note this isn't a strict boolean true, any truthy value is accepted.
# false and nil are considered failures.
# Give up after timeout seconds.
#
# Wait code from the selenium Ruby gem
# https://github.com/SeleniumHQ/selenium/blob/cf501dda3f0ed12233de51ce8170c0e8090f0c20/rb/lib/selenium/webdriver/common/wait.rb
#
# If only a number is provided then it's treated as the timeout value.
#
# @param [Hash] opts Options
# @option opts [Numeric] :timeout (30) Seconds to wait before timing out.
# @option opts [Numeric] :interval (0.5) Seconds to sleep between polls.
# @option opts [String] :message Exception message if timed out.
# @option opts [Array, Exception] :ignore Exceptions to ignore while polling (default: Exception)
def wait_true(opts = {}, &block)
  opts = WebDriverUtils._process_wait_opts(opts).merge(return_if_true: true)
  WebDriverUtils._generic_wait opts, &block
end

# Check every interval seconds to see if block.call doesn't raise an exception.
# Give up after timeout seconds.
#
# Wait code from the selenium Ruby gem
# https://github.com/SeleniumHQ/selenium/blob/cf501dda3f0ed12233de51ce8170c0e8090f0c20/rb/lib/selenium/webdriver/common/wait.rb
#
# If only a number is provided then it's treated as the timeout value.
#
# @param [Hash] opts Options
# @option opts [Numeric] :timeout (30) Seconds to wait before timing out.
# @option opts [Numeric] :interval (0.5) Seconds to sleep between polls.
# @option opts [String] :message Exception message if timed out.
# @option opts [Array, Exception] :ignore Exceptions to ignore while polling (default: Exception)
def wait(opts = {}, &block)
  opts = WebDriverUtils._process_wait_opts(opts).merge(return_if_true: false)
  WebDriverUtils._generic_wait opts, &block
end

# Return block.call and ignore any exceptions.
def ignore(&block)
  block.call
rescue Exception # rubocop:disable Lint/HandleExceptions, Lint/RescueException
end
