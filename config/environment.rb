# Load the rails application
require File.expand_path('../application', __FILE__)
LAUNCHY_DEBUG=true
#heroku config:add BUNDLE_WITHOUT="development:test"
# Initialize the rails application
Prompt::Application.initialize!
