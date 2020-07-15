# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "0.21.0"
# gem "decidim-consultations", "0.21.0"
# gem "decidim-initiatives", "0.21.0"

gem "bootsnap", "~> 1.3"

gem "puma", "~> 4.3.3"
gem "uglifier", "~> 4.1"

gem "faker", "~> 1.9"
gem "figaro", "~> 1.2"
gem "whenever", require: false
gem "delayed_job_web"
gem "ruby-ntlm"
gem "sentry-raven"
gem "rspec"


group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", "0.21.0"
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"

  gem "capistrano"
  gem "capistrano-rbenv"
  gem "capistrano-bundler"
  gem "capistrano-passenger", ">= 0.1.1"
  gem "capistrano-rails"
end

group :production do
  gem "passenger", "~> 6.0"
  gem "delayed_job_active_record", "~> 4.1"
  gem "daemons", "~> 1.3"
end
