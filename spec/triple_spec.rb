require 'spec_helper'

RSpec.describe Triple do

  specify { expect(described_class::VERSION).not_to be_nil }

  context ".adapter" do

    it "is set to sqlite3" do
      expect(described_class.adapter).to eq 'sqlite3'
    end

  end

  context ".default_database" do

    it "is set to :memory:" do
      expect(described_class.default_database).to eq ':memory:'
    end

    it "can be configured" do
      begin
        default = described_class.default_database
        described_class.default_database = 'path/to/some.db'
        expect(described_class.default_database).to eq 'path/to/some.db'
      ensure
        described_class.default_database = default
      end
    end

  end

  context ".new" do

    it "requires the :namespace argument" do
      expect{ described_class.new }.to raise_error ArgumentError
    end

    it "initializes a new triple database" do
      expect(described_class.new namespace: 'MyProject').to be_a Triple::DB
    end

  end

end
