source 'http://rubygems.org'

gem 'rails', '3.1.0'
            
#gem 'will_paginate'
gem 'heroku'
gem 'ransack'
gem 'jquery-rails'
gem "paperclip"
gem "aws-s3", :require => "aws/s3"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

group :production do
  gem 'pg'
  gem 'execjs'
  gem 'therubyracer'
  gem 'aws-sdk' 
end

group :development, :test do
  gem 'sqlite3'
  gem 'faker', '0.3.1'
  gem 'turn', :require => false
end