source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'activeadmin', '4.0.0.beta6'
gem 'aws-sdk-s3', require: false
gem 'bootstrap', '~> 5.3.3'
gem 'chartkick'
gem "cloudinary"
gem 'delayed' # delayed_job_active_record rails 7 fork: https://github.com/betterment/delayed
gem 'devise'
gem 'geocoder'
gem 'groupdate' # used by Chartkick
gem 'honeypot-captcha', github: 'founderhacker/honeypot-captcha' # prevent unauthenticated form spam
gem 'httparty'
gem "image_processing", ">= 1.2"
gem 'importmap-rails'
gem 'jbuilder'
gem 'metamagic' # easily insert metatags for SEO / opengraph
gem 'methodz' # query db-backed object methods by partial name or type
gem "pay", "~> 7.0"
gem 'pg'
gem 'postmark-rails'
gem 'pretender'
gem 'puma', '6.4.2'
gem 'pundit'
gem 'rack-cors', :require => 'rack/cors'
gem 'rails', '7.1.3.2'
gem 'redis'
gem 'rename', '1.1.3', git: 'https://github.com/ryanckulp/rename' # remove this gem after use
gem 'sass-rails', '~> 6.0'
gem 'simple_form'
gem 'split', require: 'split/dashboard'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'stripe'
gem 'tailwindcss-rails'
gem 'turbo-rails'
gem 'wicked'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem 'pry-byebug'
  gem 'rubocop', require: false # code styling
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'htmlbeautifier'
end

group :development do
  gem 'letter_opener' # view mailers in browser
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '7.0.1'
  gem 'selenium-webdriver'
  gem 'shoulda-callback-matchers'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'simplecov-tailwindcss'
  gem 'webmock'
end
