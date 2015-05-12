# webdriver_utils [![Gem Version](https://badge.fury.io/rb/webdriver_utils.svg)](https://rubygems.org/gems/webdriver_utils) [![Build Status](https://travis-ci.org/bootstraponline/webdriver_utils.svg?branch=master)](https://travis-ci.org/bootstraponline/webdriver_utils)

WebDriver utility methods.

- `require 'webdriver_utils'`

method | description
   --- | ---
**sauce_user**                         | returns ENV['SAUCE_USERNAME']
**sauce_key**                          | returns ENV['SAUCE_ACCESS_KEY']
**sauce?**                             | returns true if both sauce_user and sauce_key are true
**jenkins?**                           | returns true if running on jenkins
**WebDriverUtils.require_all_pages**   | requires all page files from Rakefile root dir
**WebDriverUtils.define_page_methods** | defines page methods
**wait**                               | generic wait until truthy method
**WebDriverUtils::Wait.new**           | selenium webdriver wait with extra validation
