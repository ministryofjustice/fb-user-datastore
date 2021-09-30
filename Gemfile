source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'bootsnap', '>= 1.1.0', require: false
gem 'rails', '~> 6.1.4'
gem 'metrics_adapter', '0.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.5'
gem 'jwt'
gem 'sentry-rails', '~> 4.7.3'
gem 'sentry-ruby', '~> 4.7.3'

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
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov'
  gem 'simplecov-console', require: false
end

gem 'tzinfo-data'
