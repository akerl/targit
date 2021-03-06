require 'spec_helper'

describe Targit do
  describe '#new' do
    it 'creates Asset objects' do
      VCR.use_cassette('current_releases') do
        asset = Targit.new(
          'spec/examples/alpha',
          'akerl/targit',
          'testing',
          authfile: 'spec/.creds',
          create: true
        )
        expect(asset).to be_an_instance_of Targit::Asset
      end
    end
  end
end
