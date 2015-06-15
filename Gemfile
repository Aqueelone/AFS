source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
gem 'rake'
# inj me

#auth
gem 'devise'
gem 'oauth2'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
gem 'omniauth-instagram'
gem 'omniauth-linkedin'
gem 'omniauth-google'

#http
gem 'protected_attributes'
# Use postgresql9.4 as the database for Active Record
gem 'pg'
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views

gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt'

# Use Unicorn as the app server
gem 'eventmachine'
gem 'em-synchrony'
gem 'em-websocket'
gem 'em-http-request'
gem 'vkontakte_api'

# Use Capistrano for deployment
gem 'capistrano-rails', group: :development
gem 'active_record-annotate', group: :development

gem 'actionmailer'

gem 'whenever'

gem 'tinymce-rails'

gem 'therubyracer'
gem 'less-rails'
gem "twitter-bootstrap-rails"
gem 'compass'

gem 'turbolinks'
gem 'jquery-turbolinks'

group :production do # we don"t install these on travis to speed up test runs
  # Administration

  gem "rails_admin", "0.6.7"

  # Analytics

  gem "rack-google-analytics"
  gem "rack-piwik", require: "rack/piwik"

  # Click-jacking protection

  gem "rack-protection"

  # Process management

  gem "eye"

  # Redirects

  gem "rack-rewrite", require: true
  gem "rack-ssl", require: "rack/ssl"

  # Third party asset hosting

  gem "asset_sync", require: true
end

group :development do
  # Automatic test runs
  gem "guard-cucumber"
  gem "guard-jshintrb"
  gem "guard-rspec"
  gem "guard-rubocop"
  gem "guard", require: true
  gem "rb-fsevent", require: true
  gem "rb-inotify", require: true

  # Linters
  gem "jshintrb"
  gem "rubocop"

  # Preloading environment

  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-commands-cucumber"

end

group :test do
  # RSpec (unit tests, some integration tests)

  gem "fixture_builder"
  gem "fuubar"
  gem "rspec-instafail", require: false
  gem "test_after_commit"

  # Cucumber (integration tests)

  gem "capybara"
  gem "database_cleaner"
  gem "selenium-webdriver"

  source "https://rails-assets.org" do
    gem "rails-assets-jquery-simulate"
    gem "rails-assets-jquery-simulate-ext"
  end

  # General helpers

  gem "factory_girl_rails"
  gem "timecop"
  gem "webmock", require: false
  gem "shoulda-matchers", require: false
end

group :development, :test do
  # RSpec (unit tests, some integration tests)
  gem "rspec-rails"

  # Cucumber (integration tests)
  gem "cucumber-rails", require: false

  # Jasmine (client side application tests (JS))
  gem "jasmine"
  gem "jasmine-jquery-rails"
  gem "rails-assets-jasmine-ajax", source: "https://rails-assets.org"
  gem "sinon-rails"

  # silence assets
  gem "quiet_assets"
  
  # local env up
  gem 'dotenv-rails'
end

