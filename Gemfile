source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'bootsnap', '>= 1.1.0', require: false
gem 'rails', '~> 7.0.4.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 6.1'
gem 'jwt'
gem 'sentry-rails', '~> 5.8.0'
gem 'sentry-ruby', '~> 5.8.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '>= 3.5.0'
  gem 'dotenv-rails', require: 'dotenv/rails-now'
end

group :development do
  gem 'listen'
  gem 'guard-rspec', require: false
  gem 'guard-shell'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'shoulda-matchers', '~> 5.3'
  gem 'simplecov'
  gem 'simplecov-console', require: false
end

gem 'tzinfo-data'
gem 'net-smtp', require: false
gem 'net-pop', require: false
gem 'net-imap', require: false
