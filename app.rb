require './idea'
require 'bundler'
Bundler.require

class IdeaBoxApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index
  end

  not_found do
    erb :error
  end

  post '/' do
  # 1. Create an idea based on the form parameters
  idea = Idea.new

  # 2. Store it
  idea.save

  # 3. Send us back to the index page to see all ideas
  "Creating an idea!"
  end
end
