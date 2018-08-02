require 'spec_helper'

RSpec.describe 'Triple', type: :model do

  let(:model) { 'Triple' }

  let(:namespace) { 'Testing' }

  let(:klass) { "#{namespace}::#{model}".constantize }

  let(:triple) do
    Triple.new namespace: namespace, database: data('models.db')
  end

  before(:each) do
    ActiveRecord::Schema.verbose = false
    File.delete(data('models.db')) if File.exist?(data('models.db'))
    triple.setup
  end

  after(:each) do
    triple.teardown
    File.delete(data('models.db')) if File.exist?(data('models.db'))
    ActiveRecord::Schema.verbose = true
  end

  context "relationships" do

    subject { klass.new }

    it "belongs to source" do
      is_expected.to belong_to(:source).class_name("#{namespace}::Source")
    end

    it "belongs to entity" do
      is_expected.to belong_to(:entity).class_name("#{namespace}::Entity")
    end

    it "belongs to concept" do
      is_expected.to belong_to(:concept).class_name("#{namespace}::Concept")
    end

    it "belongs to value" do
      is_expected.to belong_to(:value).dependent(:destroy)
    end

  end

end
