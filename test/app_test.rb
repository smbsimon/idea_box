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

  def idea_store
    @idea_store ||= IdeaStore.new(IdeaBoxApp.database_path)
  end

  before do
    idea_store.salt_the_earth!
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
    idea_store.create 'title'       => "ONE",
                      'description' => "description",
                      'rank'        => 1
    idea_store.create 'title'       => "TWO",
                      'description' => "description",
                      'rank'        => 0
    # higher priority shows up first
    request = get '/'
    titles = request.body.scan(/ONE|TWO/)
    assert_equal ['ONE', 'TWO'], titles

    # bump the bottom one twice
    post "/1/like"
    assert_equal 302, last_response.status
    post "/1/like"
    assert_equal 302, last_response.status

    # go to the homepage the bumped one should be on top
    request = get '/'
    titles = request.body.scan(/ONE|TWO/)
    assert_equal ['TWO', 'ONE'], titles
  end

  it 'can edit tasks'
  it 'can delete tasks'
end
