source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'bootsnap', '>= 1.1.0', require: false
gem 'rails', '~> 7.1.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 6.4'
gem 'jwt'
gem 'sentry-rails', '~> 5.13'
gem 'sentry-ruby', '~> 5.13'
gem 'tzinfo-data'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'dotenv', require: 'dotenv/load'
end

group :development do
  gem 'listen'
  gem 'guard-rspec', require: false
  gem 'guard-shell'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'shoulda-matchers', '~> 5.3'
  gem 'simplecov'
  gem 'simplecov-console', require: false
end
