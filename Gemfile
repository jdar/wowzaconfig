source 'http://rubygems.org'

ruby '2.0.0'

# Sinatra microframework
gem 'rack'
gem 'rake'
gem 'sinatra', require: "sinatra/base"
gem 'sinatra-contrib'
gem 'multi_json'

# Serve with unicorn
gem 'unicorn'

group :development, :test do
  gem 'guard-minitest'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'rack-test', '~> 0.6.1'
  gem 'mocha', '~> 0.14.0', require: false
  gem 'simplecov', require: false
  gem 'coveralls', require: false
  gem 'pry'
end
