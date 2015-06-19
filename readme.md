# webdriver_utils [![Gem Version](https://badge.fury.io/rb/webdriver_utils.svg)](https://rubygems.org/gems/webdriver_utils) [![Build Status](https://travis-ci.org/bootstraponline/webdriver_utils.svg?branch=master)](https://travis-ci.org/bootstraponline/webdriver_utils) [![Dependency Status](https://gemnasium.com/bootstraponline/webdriver_utils.svg?nocache)](https://gemnasium.com/bootstraponline/webdriver_utils)

WebDriver utility methods.

- `require 'webdriver_utils'`

#### example

[Example tests that use webdriver_utils](https://github.com/bootstraponline/sauce_connect_ruby). This repo is part of a larger [angular_automation](https://github.com/bootstraponline/angular_automation) effort although it can be used standalone.

#### methods

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
