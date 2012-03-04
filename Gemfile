source 'https://rubygems.org'

gem 'rails', '3.2.0'
gem 'jquery-rails'
gem 'haml'
gem 'haml-rails', :group => :development
gem 'devise'
gem 'cancan'
#gem "twitter-bootstrap-rails", "~> 2.0.1.0"
gem 'twitter-bootstrap-rails', :git => 'http://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'simple_form', '~> 2.0'
gem 'pry', :group => :development

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'spork-rails'
  gem 'factory_girl_rails'
end
