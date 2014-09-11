require_relative './idea_box'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  not_found do
    erb :error
  end

  def self.database_path
    "database/ideabox-#{ENV['RACK_ENV']}"
  end

  # "database/ideabox"             # <-- old
  # "database/ideabox-test"        # <-- new for test
  # "database/ideabox-development" # <-- new for dev
  def idea_store
    @idea_store ||= IdeaStore.new(IdeaBoxApp.database_path)
  end

  # Haven't initialized IdeaStore with any data, so it must internally know how to find ideas
  # :D
  get '/' do
    erb :index, locals: {
      ideas: idea_store.all.sort,
      idea: Idea.new(params)
    }
  end

  # :D
  post '/' do
    idea_store.create(params[:idea])
    redirect '/'
  end

  # :(
  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  # :(
  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  # :(
  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  # :D
  post '/:id/like' do |id|
    idea = idea_store.find(id.to_i)
    idea.like!
    idea_store.update(id.to_i, idea.to_h)
    redirect '/'
  end
end
