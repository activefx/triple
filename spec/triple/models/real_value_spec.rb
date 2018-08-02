require 'spec_helper'

RSpec.describe 'RealValue', type: :model do

  let(:model) { 'RealValue' }

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

    it "have one triples" do
      is_expected.to have_one(:triple)
    end

  end

end
