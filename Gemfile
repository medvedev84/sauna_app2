source 'http://rubygems.org'

gem 'rails', '3.1'
            
gem 'kaminari'

gem 'heroku'
gem 'ransack'
gem 'jquery-rails'
gem "bcrypt-ruby"

gem "cocaine", "0.3.2"

# for image manipulaton and storage
gem "paperclip", "2.7.0" 
gem "aws-s3", :require => "aws/s3"
gem "aws-sdk", "1.3.7"


# for date and time validating
gem 'validates_timeliness', '~> 3.0.2' 

# datepicker for rails
gem 'jquery_datepicker'

# captcha
gem "galetahub-simple_captcha", :require => "simple_captcha"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1"
  gem 'coffee-rails', "~> 3.1"
  gem 'uglifier'
end

group :production do
  gem 'pg'
 # gem 'execjs'
 # gem 'libv8', '~> 3.11.8'  
 # gem 'therubyracer', :require => 'v8'
end

group :development, :test do
  gem 'sqlite3'
  gem 'faker', '0.3.1'
  gem 'turn', :require => false
end