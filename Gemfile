source 'http://rubygems.org'

gem 'rails', '3.1'
            
gem 'will_paginate'
gem 'heroku'
gem 'ransack'
gem 'jquery-rails'
gem "bcrypt-ruby"

gem "paperclip", "2.7.0" 
gem "aws-s3", :require => "aws/s3"
gem "aws-sdk", "1.3.7"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1"
  gem 'coffee-rails', "~> 3.1"
  gem 'uglifier'
end

group :production do
  gem 'pg'
  gem 'execjs'
  gem 'therubyracer' 
end

group :development, :test do
  gem 'sqlite3'
  gem 'faker', '0.3.1'
  gem 'turn', :require => false
end