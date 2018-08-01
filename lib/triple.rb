require 'triple/version'

require 'sqlite3'
require 'active_record'

require 'triple/schema'
require 'triple/db'

module Triple

  @adapter = 'sqlite3'.freeze

  @default_database = ':memory:'

  def self.adapter
    @adapter
  end

  def self.default_database
    @default_database
  end

  def self.default_database=(value)
    @default_database = value
  end

  def self.new(**options)
    DB.new(options)
  end

end
