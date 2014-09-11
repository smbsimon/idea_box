require 'sinatra/base'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'rack/test'

require_relative './lib/app'

describe IdeaBoxApp do
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  it "provides user a place to record ideas" do
    get '/'
    assert_equal 200, last_response.status
    assert last_response.ok?
  end

  it "doesn't find routes that don't exist" do
    get '/this-route-does-not-exist'
    assert_equal 404, last_response.status
  end

  it "stores ideas and descriptions after entered on form" do
    post '/', idea: { title: "test-idea", description: "test-description" }
    follow_redirect!
    assert last_response.ok?
    assert last_response.body.include? "test-idea"
  end
end
