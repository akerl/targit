require 'spec_helper'

describe Targit do
  describe Targit::Asset do
    let(:asset) do
      VCR.use_cassette('current_asset') do
        Targit.new(
          'spec/examples/alpha',
          'akerl/targit',
          'testing',
          authfile: 'spec/.creds'
        )
      end
    end
    let(:io_asset) do
      VCR.use_cassette('current_io_asset') do
        fh = File.open('spec/examples/alpha')
        Targit.new(
          fh,
          'akerl/targit',
          'testing',
          authfile: 'spec/.creds',
          create: true
        )
      end
    end

    it 'exposes the release object' do
      expect(asset.release).to be_an_instance_of Targit::Release
    end
    it 'exposes the asset attribute' do
      expect(asset.asset).to eql 'spec/examples/alpha'
    end
    it 'exposes the asset name' do
      expect(asset.name).to eql 'alpha'
      expect(io_asset.name).to eql 'alpha'
    end

    it 'does not create a release by default' do
      VCR.use_cassette('asset_without_release') do
        expect do
          Targit.new(
            'spec/examples/beta',
            'akerl/targit',
            'more_testing',
            authfile: 'spec/.creds'
          )
        end.to raise_error RuntimeError, /No release found/
      end
    end

    it 'can create a new release' do
      VCR.use_cassette('asset_autocreate_release') do
        expect do
          Targit.new(
            'spec/examples/beta',
            'akerl/targit',
            'more_testing',
            authfile: 'spec/.creds'
          )
        end.to raise_error RuntimeError, /No release found/
        asset = Targit.new(
          'spec/examples/beta',
          'akerl/targit',
          'more_testing',
          authfile: 'spec/.creds',
          create: true
        )
        expect(asset.release).to be_an_instance_of Targit::Release
      end
    end

    describe '#upload!' do
      it 'uploads a release asset' do
        VCR.use_cassette('create_new_asset') do
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
      it 'will fail to replace an existing asset by default' do
        VCR.use_cassette('block_existing_asset') do
          asset = Targit.new(
            'spec/examples/beta',
            'akerl/targit',
            'testing',
            authfile: 'spec/.creds',
          )
          expect { asset.upload! }.to raise_error RuntimeError, /already exists/
        end
      end
      it 'can replace an existing asset' do
        VCR.use_cassette('replace_existing_asset') do
          asset = Targit.new(
            'spec/examples/beta',
            'akerl/targit',
            'testing',
            authfile: 'spec/.creds',
            force: true
          )
          expect(asset.url).to eql 'https://github.com/akerl/targit/releases/download/testing/beta'
          asset.upload!
          expect(asset.url).to eql 'https://github.com/akerl/targit/releases/download/testing/beta'
        end
      end
    end

    describe '#already_exists?' do
      it 'returns true if the asset is on GitHub' do
        VCR.use_cassette('asset_existence_check_pass') do
          asset = Targit.new(
            'spec/examples/beta',
            'akerl/targit',
            'testing',
            authfile: 'spec/.creds'
          )
          expect(asset.already_exists?).to be_truthy
        end
      end
      it 'returns false if the asset is not on GitHub' do
        VCR.use_cassette('asset_existence_check_fail') do
          asset = Targit.new(
            'spec/examples/charlie',
            'akerl/targit',
            'testing',
            authfile: 'spec/.creds'
          )
          expect(asset.already_exists?).to be_falsey
        end
      end
    end

    describe '#delete!' do
      it 'removes the asset from GitHub' do
        VCR.use_cassette('delete_asset') do
          asset = Targit.new(
            'spec/examples/beta',
            'akerl/targit',
            'testing',
            authfile: 'spec/.creds'
          )
          expect(asset.already_exists?).to be_truthy
          asset.delete!
          expect(asset.already_exists?).to be_falsey
        end
      end
    end

    describe '#github_data' do
      it 'returns the GitHub metadata for this asset' do
        VCR.use_cassette('asset_metadata_present') do
          asset = Targit.new(
            'spec/examples/beta',
            'akerl/targit',
            'meta_testing',
            authfile: 'spec/.creds',
            create: true
          )
          asset.upload!
          expect(asset.github_data[:name]).to eql 'beta'
        end
      end
      it 'returns nil if the asset is not on GitHub' do
        VCR.use_cassette('asset_metadata_absent') do
          asset = Targit.new(
            'spec/examples/charlie',
            'akerl/targit',
            'testing',
            authfile: 'spec/.creds'
          )
          expect(asset.github_data).to be_nil
        end
      end
    end

    describe '#url' do
      it 'returns the download URL if the asset is on GitHub' do
        VCR.use_cassette('asset_url_present') do
          asset = Targit.new(
            'spec/examples/beta',
            'akerl/targit',
            'testing',
            authfile: 'spec/.creds',
            force: true
          )
          asset.upload!
          expect(asset.url).to eql 'https://github.com/akerl/targit/releases/download/testing/beta'
        end
      end
      it 'raises if the asset is not on GitHub' do
        VCR.use_cassette('asset_url_absent') do
          asset = Targit.new(
            'spec/examples/beta',
            'akerl/targit',
            'testing',
            authfile: 'spec/.creds',
            create: true
          )
          asset.delete!
          expect { asset.url }.to raise_error RuntimeError, /URL not found/
        end
      end
    end
  end
end
