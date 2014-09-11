require_relative './idea_box'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  not_found do
    erb :error
  end

  def idea_store
    @idea_store ||= IdeaStore.new
  end

  # Haven't initialized IdeaStore with any data, so it must internally know how to find ideas
  # :D
  get '/' do
    erb :index, locals: {
      ideas: idea_store.all.sort,
      idea: Idea.new(params)
    }
  end

  # :)
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

  # :(
  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end
end
