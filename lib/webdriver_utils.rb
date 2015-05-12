require 'rubygems'
require 'selenium-webdriver'

require_relative 'webdriver_utils/page'
require_relative 'webdriver_utils/sauce'
require_relative 'webdriver_utils/silence_gem_warnings'
require_relative 'webdriver_utils/version'
require_relative 'webdriver_utils/wait'

WebDriverUtils.silence_gem_warnings
