module WebDriverUtils
  class << self
    def silence_gem_warnings
      # https://github.com/appium/ruby_console/blob/1049c515432212f164cfbabd413d6e3d82e4aada/lib/appium_console.rb#L5
      Gem::Specification.class_eval do
        def self.warn args
        end
      end
    end
  end # class << self
end # module WebDriverUtils
