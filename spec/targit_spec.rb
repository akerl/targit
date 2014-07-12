require 'spec_helper'

describe Targit do
  describe '#new' do
    it 'creates Asset objects' do
      stub_request(:get, 'https://api.github.com/repos/akerl/targit/releases?per_page=100')
        .to_return(status: 200, body: [{ tag_name: 'testing' }], headers: {})
      asset = Targit.new(
        'spec/examples/alpha',
        'akerl/targit',
        'testing',
        authfile: 'spec/.creds'
      )
      expect(asset).to be_an_instance_of Targit::Asset
    end
  end
end
