require 'spec_helper'

RSpec.describe Triple::DB do

  specify { expect{ described_class.new }.not_to raise_error }

  context ".new" do

    it "uses an in-memory database by default" do
      instance = described_class.new
      expect(instance.database).to eq ':memory:'
    end

    it "does not have a namespace by default" do
      instance = described_class.new
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

end
