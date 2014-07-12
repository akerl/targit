require 'spec_helper'

describe Targit do
  describe Targit::Asset do
    let(:asset) do
      VCR.use_cassette('current_releases') do
        Targit.new(
          'spec/examples/alpha',
          'akerl/targit',
          'testing',
          authfile: 'spec/.creds'
        )
      end
    end
    let(:io_asset) do
      VCR.use_cassette('current_releases') do
        fh = File.open('spec/examples/alpha')
        Targit.new(
          fh,
          'akerl/targit',
          'testing',
          authfile: 'spec/.creds'
        )
      end
    end

    it 'exposes the release object' do
      expect(asset.release).to be_an_instance_of Targit::Release
    end
    it 'exposes the asset attribute' do
      expect(asset.asset).to eql 'spec/examples/alpha'
    end
    it 'expostes the asset name' do
      expect(asset.name).to eql 'alpha'
      expect(io_asset.name).to eql 'alpha'
    end

    describe '#upload!' do
      it 'uploads a release asset' do
        VCR.use_cassette('create_new_release') do
          asset = Targit.new(
            'spec/examples/beta',
            'akerl/targit',
            'testing',
            authfile: 'spec/.creds'
          )
          expect { asset.url }.to raise_error RuntimeError, /URL not found/
          asset.upload!
          expect(asset.url).to eql 'https://github.com/akerl/targit/releases/download/testing/beta'
        end
      end
    end
  end
end
