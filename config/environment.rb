# Load the Rails application.
require File.expand_path('../application', __FILE__)

APP_NAME = Rails.application.class.to_s.split("::").first.downcase

# Initialize the Rails application.
Rails.application.initialize!
