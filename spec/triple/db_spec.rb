require 'spec_helper'

RSpec.describe Triple::DB do

  let(:instance) { described_class.new }

  before(:all) do
    ActiveRecord::Schema.verbose = false
    ActiveRecord::Base.remove_connection
    File.delete(data('working.db')) if File.exist?(data('working.db'))
  end

  after(:each) do
    ActiveRecord::Base.remove_connection
    File.delete(data('working.db')) if File.exist?(data('working.db'))
  end

  after(:all) do
    ActiveRecord::Schema.verbose = true
  end

  specify { expect{ described_class.new }.not_to raise_error }

  context ".new" do

    it "uses an in-memory database by default" do
      expect(instance.database).to eq ':memory:'
    end

    it "does not have a namespace by default" do
      expect(instance.namespace).to be_nil
    end

  end

  context "#version" do

    it "is 1 by default" do
      expect(instance.version).to eq 1
    end

    it "can be configured during initialization" do
      instance = described_class.new version: 2
      expect(instance.version).to eq 2
    end

    it "requires an integer" do
      expect{ described_class.new version: 'A' }.to raise_error ArgumentError
    end

  end

  context "#namespace" do

    it "is always retrieved as a string" do
      instance = described_class.new namespace: Triple
      expect(instance.namespace).to eq 'Triple'
    end

    it "require a valid Ruby class or module name" do
      ['triple', 'SOME_CLASS', 'aClass', 'Triple_'].each do |name|
        instance = described_class.new namespace: name
        expect{ instance.namespace }.to raise_error StandardError
      end
    end

  end

  context "#force?" do

    it "can be configured to true to overwrite the schema" do
      instance = described_class.new force: true
      expect(instance.force?).to eq true
    end

    it "is false by default" do
      expect(instance.force?).to eq false
    end

    it "must explicitly be set to true" do
      instance = described_class.new force: 'true'
      expect(instance.force?).to eq false
    end

  end

  context "#using_connection?" do

    it "returns false with no connection" do
      expect(instance).not_to be_using_connection
    end

    it "returns true when using the configured connection" do
      instance.with_connection do
        expect(instance).to be_using_connection
      end
    end

  end

  context "#connection_options" do

    it "provides the :adapter key" do
      expect(instance.connection_options[:adapter]).to eq Triple.adapter
    end

    it "provides the :database key" do
      expect(instance.connection_options[:database]).to eq ':memory:'
    end

  end

  context "#with_connection" do

    let(:establish_connection) do
      ActiveRecord::Base.establish_connection \
        adapter: 'sqlite3',
        database: data('with_connection.db')
    end

    after(:each) do
      ActiveRecord::Base.remove_connection
    end

    it "connects the database without a current connection" do
      instance.with_connection do
        expect(ActiveRecord::Base.connection_config[:database]).to eq ':memory:'
      end
    end

    it "removes the current ActiveRecord connection before establishing the connection" do
      establish_connection
      expect(ActiveRecord::Base.connection_config[:database]).to eq data('with_connection.db')
      instance.with_connection do
        expect(ActiveRecord::Base.connection_config[:database]).to eq ':memory:'
      end
    end

    it "restores the previous ActiveRecord connection if one existed" do
      establish_connection
      instance.with_connection do
        expect(ActiveRecord::Base.connection_config[:database]).to eq ':memory:'
      end
      expect(ActiveRecord::Base.connection_config[:database]).to eq data('with_connection.db')
    end

  end

  context "#setup" do

    let(:namespace) { 'DatabaseTest' }

    let(:instance) do
      described_class.new namespace: namespace, database: data('working.db')
    end

    after(:each) do
      instance.teardown
    end

    it "loads the schema" do
      instance.setup
      instance.with_connection do
        result = ActiveRecord::Base.connection.execute \
          "SELECT name FROM sqlite_master WHERE type='table' AND name='entities';"
        expect(result).not_to be_empty
      end
    end

    it "does not interfere with an existing ActiveRecord connection" do
      ActiveRecord::Base.establish_connection \
        adapter: 'sqlite3',
        database: data('existing.db')
      instance.setup
      conn = ActiveRecord::Base.establish_connection \
        adapter: 'sqlite3',
        database: data('existing.db')
      result = conn.connection.execute \
        "SELECT name FROM sqlite_master WHERE type='table' AND name='entities';"
      expect(result).to be_empty
    end

    it "does not reload the schema on subsequent calls"

    it "reloads the schema with configuration option force: true"

    it "creates the models" do
      instance.setup
      expect(namespace.constantize).to be_abstract_class
      %w[ Source Entity Attribute Triple DefaultValue BooleanValue
          StringValue IntegerValue RealValue NumericValue DateValue
          TimeValue DatetimeValue BinaryValue ].each do |data_model|
        expect("#{namespace}::#{data_model}".constantize.ancestors)
          .to include(ActiveRecord::Base)
      end
    end

  end

end
