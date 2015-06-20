# top level sauce helper methods

# Returns sauce username if env is set and not empty.
# If env isn't defined then nil is returned.
def sauce_user
  env = ENV['SAUCE_USERNAME']
  (env && !env.empty?) ? env : nil
end

# Returns sauce key if env is set and not empty.
# If env isn't defined then nil is returned.
def sauce_key
  env = ENV['SAUCE_ACCESS_KEY']
  (env && !env.empty?) ? env : nil
end

# Returns true if both sauce user and sauce key are defined.
# Returns false if they're not defined.
def sauce?
  !!(sauce_user && sauce_key)
end

# Returns true if env is set and not empty
# Returns false if env is not set or empty.
def jenkins?
  env = ENV['JENKINS_SERVER_COOKIE']
  env && !env.empty?
end
