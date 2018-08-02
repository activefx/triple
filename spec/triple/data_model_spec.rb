require 'spec_helper'

RSpec.describe Triple::DataModel do

  let(:namespace) { 'Sample' }

  let(:connection_options) do
    { adapter: 'sqlite3', database: ':memory:' }
  end

  let(:instance) { described_class.new }

  before(:all) do
    ActiveRecord::Base.remove_connection
  end

  context ".build" do

    before(:each) do
      described_class.build \
        namespace: namespace, connection_options: connection_options
    end

    after(:each) do
      described_class.teardown namespace: namespace
    end

    it "creates an abstract base class with the namespace" do
      expect(namespace.constantize).to be_abstract_class
    end

    it "creates the models" do
      %w[ Source Entity Concept Triple DefaultValue BooleanValue
          StringValue IntegerValue RealValue NumericValue DateValue
          TimeValue DatetimeValue BinaryValue ].each do |data_model|
        expect("#{namespace}::#{data_model}".constantize.ancestors)
          .to include(ActiveRecord::Base)
      end
    end

    it "creates a database connection" do
      expect(namespace.constantize.connection_config[:database])
        .to eq connection_options[:database]
    end

  end

  context ".teardown" do

    before(:each) do
      described_class.build \
        namespace: namespace, connection_options: connection_options
    end

    it "removes the connection" do
      described_class.teardown namespace: namespace
      expect{ ActiveRecord::Base.connection }
        .to raise_error ActiveRecord::ConnectionNotEstablished
    end

    it "removes the constants" do
      described_class.teardown namespace: namespace
      expect{ namespace.constantize }.to raise_error NameError
    end

  end

end
