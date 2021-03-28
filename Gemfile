source "https://rubygems.org"


## replaced below line due to an error: 'ruby stdout: Ruby ruby-2.6.6 is not installed.''
## https://vle.shef.ac.uk/ultra/courses/_90050_1/cl/outline?legacyUrl=%252Fwebapps%252Fblackboard%252Fexecute%252Fannouncement%3Fmethod%3Dsearch%26context%3Dmybb%26course_id%3D_90050_1%26individualAnnouncementId%3D_183481_1
## if the server is upgraded to 2.6.6, please uncommented the change
ruby '2.6.6'
# ruby '~> 2.6.2'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }
git_source(:gitlab) { |repo_name| "https://git.shefcompsci.org.uk/#{repo_name}.git" }

gem 'airbrake', github: 'epigenesys/airbrake', branch: 'airbrake-v4'
gem 'rubycas-client', gitlab: 'gems/rubycas-client'
gem 'epi_js'

gem 'rails', '6.0.3.3'
gem 'activerecord-session_store'
gem 'bootsnap'
gem 'responders'
gem 'puma'

gem 'pg'

gem 'haml-rails'
gem 'sassc-rails'
gem 'sassc'
gem 'uglifier'
gem 'coffee-rails'

gem 'jquery-rails'
gem 'bootstrap'
gem 'font-awesome-sass'
# select2-rails is vendored under vendor/assets

gem 'simple_form'
gem 'draper'
gem 'ransack'

gem 'will_paginate'
gem 'bootstrap-will_paginate'

gem 'devise'
gem 'epi_cas', git: 'git@git.shefcompsci.org.uk:gems/epi_cas.git'
gem 'devise_ldap_authenticatable'
gem 'devise_cas_authenticatable'
gem 'cancancan'

gem 'whenever'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'delayed-plugins-airbrake'
gem 'daemons', '1.1.9'

group :development, :test do
  gem 'rspec-rails'
  gem 'byebug'
  gem 'sqlite3'
end

group :development do
  gem 'epi_deploy', github: 'epigenesys/epi_deploy'

  gem 'listen'
  gem 'web-console'

  gem 'capistrano'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false

  gem 'eventmachine'
  gem 'letter_opener'
  gem 'annotate'
end

group :test do
  gem 'capybara-select2', github: 'goodwill/capybara-select2'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'webdrivers'
  gem 'rspec-instafail', require: false

  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov'
end
