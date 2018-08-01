require 'spec_helper'

RSpec.describe Triple::DB do

  specify { expect{ described_class.new }.not_to raise_error }

end
