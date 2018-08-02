require 'spec_helper'

RSpec.describe Triple::Schema do

  let(:establish_connection) do
    ActiveRecord::Base.establish_connection \
      adapter: 'sqlite3',
      database: data('schema.db')
  end

  before(:all) do
    ActiveRecord::Schema.verbose = false
    File.delete(data('schema.db')) if File.exist?(data('schema.db'))
  end

  after(:each) do
    ActiveRecord::Base.remove_connection
    File.delete(data('schema.db')) if File.exist?(data('schema.db'))
  end

  after(:all) do
    ActiveRecord::Schema.verbose = true
  end

  context ".call" do

    it "generates the tables" do
      ar_connection = establish_connection
      described_class.call
      tables = %w[ sources entities concepts triples default_values
        boolean_values string_values integer_values real_values numeric_values
        date_values time_values datetime_values binary_values ]
      tables.each do |table_name|
        result = ar_connection.connection.execute \
          "SELECT name FROM sqlite_master WHERE type='table' AND name='#{table_name}';"
        expect(result).not_to be_empty
      end
    end

    it "regenerates the tables on subsequent calls" do
      ar_connection = establish_connection
      described_class.call
      insert_statement = "INSERT INTO sources (ID,NAME,CREATED_AT,UPDATED_AT) " +
        "VALUES (1, 'Source Name', DATETIME('now'), DATETIME('now'));"
      ar_connection.connection.execute(insert_statement)
      query_statement = "SELECT * FROM sources;"
      result = ar_connection.connection.execute(query_statement)
      expect(result).not_to be_empty
      described_class.call
      result = ar_connection.connection.execute(query_statement)
      expect(result).to be_empty
    end

  end

end
