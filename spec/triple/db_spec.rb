require 'spec_helper'

RSpec.describe Triple::DB do

  let(:instance) { described_class.new }

  specify { expect{ described_class.new }.not_to raise_error }

  context ".new" do

    it "uses an in-memory database by default" do
      expect(instance.database).to eq ':memory:'
    end

    it "does not have a namespace by default" do
      expect(instance.namespace).to be_nil
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

end
