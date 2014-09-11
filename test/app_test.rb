require 'sinatra/base'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

require_relative '../lib/app'

describe IdeaBoxApp do
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  before do
    IdeaStore.new(IdeaBoxApp.database_path)
             .salt_the_earth!
  end

  describe 'homepage' do
    it "provides user a place to record ideas" do
      get '/'
      assert_equal 200, last_response.status
      # assert the form is on the page,
      # and the names look like the data that I'm posting
      assert last_response.ok?
    end

    it "stores ideas and descriptions after entered on form" do
      post '/', idea: { title: "test-idea",
                        description: "test-description" }
      follow_redirect!
      assert last_response.ok?
      assert last_response.body.include? "test-idea"
    end

    it 'shows the task list in order of priority'
  end

  it "doesn't find routes that don't exist" do
    get '/this-route-does-not-exist'
    assert_equal 404, last_response.status
  end

  it 'can bump the priority of the tasks' do
    # put two tasks into the db
    # go to the homepage
    # bump the bottom one
    # go to the homepage
    # the bumped one should be on top
  end

  it 'can edit tasks'
  it 'can delete tasks'
end
