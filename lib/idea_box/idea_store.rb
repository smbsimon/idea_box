require 'yaml/store'

# reimplement all class methods as instance methods
# (without breaking anything ;)
#
# Inject the data necessary to connect to the database
#
# Determine what it is from the ENV['RACK_ENV']
#
# Write unit tests on IdeaStore


class IdeaStore
  attr_reader :database

  def initialize(db_path)
    @database = YAML::Store.new(db_path)
    @database.transaction do
      @database['ideas'] ||= []
    end
  end

  def all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def create(data)
    database.transaction do
      database['ideas'] << data
    end
    data
  end

  def salt_the_earth!
    database.transaction do
      database['ideas'] = []
    end
  end

  def find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end

  # Below be class methods!
  def self.database
    return @database if @database

    @database ||= YAML::Store.new('database/ideabox')
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end

  def self.create(data)
    database.transaction do
      database['ideas'] << data
    end
  end
end
