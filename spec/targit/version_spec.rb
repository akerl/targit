require 'spec_helper'

describe Targit do
  describe '::VERSION' do
    it 'follows the semantic version scheme' do
      expect(Targit::VERSION).to match(/\d+\.\d+\.\d+/)
    end
  end
end
