# top level sauce helper methods

def sauce_user
  ENV['SAUCE_USERNAME']
end

def sauce_key
  ENV['SAUCE_ACCESS_KEY']
end

def sauce?
  !!(sauce_user && sauce_key)
end

def jenkins?
  !!ENV['JENKINS_SERVER_COOKIE']
end
