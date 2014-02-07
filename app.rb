require 'yaml'
require 'fileutils'
require 'better_errors'

ENV['RACK_ENV'] ||= 'development'

# Autoload gems from the Gemfile
require "bundler"
Bundler.require :default, ENV['RACK_ENV'].to_sym

# Helpers
module JsonHelpers
  def json(hash)
    MultiJson.dump(hash, pretty: true)
  end

  def parsed_params
    if request.get? || request.form_data?
      parsed = params
    else
      parsed = MultiJson.load(request.body, symbolize_keys: true)
    end

    parsed = {} unless parsed.is_a?(Hash)

    return parsed
  end
end


# Define app and setup root helper
module Api
  class Base < ::Sinatra::Base
    set :root, lambda { |*args| File.join(File.dirname(__FILE__), *args) }

    configure do
      set :static_cache_control, [:private, max_age: 0, must_revalidate: true]

      use ::BetterErrors::Middleware
      ::BetterErrors.application_root = __dir__

      # Register plugins
      register ::Sinatra::Namespace

      # Set default content type to json
      before do
        content_type :json
      end
    end

    helpers JsonHelpers

    get '/set' do
      yaml = unless params[:json].strip.empty?
          YAML.dump(JSON.parse params[:json])
      else
          params[:yaml] || raise("no content given")
      end
      File.open("/tmp/temporary.yaml", "w+") {|f| f.puts yaml }
      FileUtils.mkdir_p "public"
      File.open("public/settings.yaml", "w+") {|f| f.puts yaml }
      File.open("public/settings.json", "w+") {|f| f.puts JSON.pretty_generate(YAML.load_file "public/temporary.yaml") }
      json({ status: "success" })
    end

    get '/get' do
      json(YAML.load_file "/tmp/temporary.yaml")
    end

    namespace '/api/v1' do

      get '/?' do
        json({ status: "success", message: "API v1" })
      end

      get '/users' do
        users = ["bob", "andy", "john"]
        json({ status: "success", users: users })
      end

      post '/users' do
        user = parsed_params[:user]
        json({ status: "success", user: user })
      end


    end
  end
end
