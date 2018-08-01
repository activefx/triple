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

end
