source 'https://rubygems.org'

gem 'rails', '4.0.2'
gem 'rake'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'uglifier', '>= 1.3.0'
gem "therubyracer"
gem "less-rails"
gem "sass-rails"
gem "twitter-bootstrap-rails"
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'heroku'
gem 'activerecord-session_store', git: 'https://github.com/rails/activerecord-session_store'


group :production do
  gem 'pg'
  gem 'rails_12factor', group: :production
end

group :test, :development do
  gem 'sqlite3'
  gem "cucumber"  
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem "rspec-rails"
  gem 'byebug'
end


