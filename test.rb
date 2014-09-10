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

  it "provides you a place to record ideas" do
    get '/'
    assert_equal 200, last_response.status
    assert last_response.ok?
  end
end
