require 'spec_helper'

describe Targit do
  describe Targit::Release do
    let(:basic_release) do
      VCR.use_cassette('release_object') do
        Targit::Release.new 'akerl/targit', 'testing', authfile: 'spec/.creds'
      end
    end

    it 'exposes the release object' do
      expect(basic_release.data[:tag_name]).to eql 'testing'
    end
    it 'exposes the repo name' do
      expect(basic_release.repo).to eql 'akerl/targit'
    end
    it 'exposes the tag name' do
      expect(basic_release.tag).to eql 'testing'
    end

    it 'does not create a new release by default' do
      VCR.use_cassette('no_release_found') do
        expect do
          Targit::Release.new(
            'akerl/targit', 'new_release', authfile: 'spec/.creds'
          )
        end.to raise_error RuntimeError, /No release found/
      end
    end

    it 'creates the repo if called with :create = true' do
      VCR.use_cassette('create_new_release') do
        release = Targit::Release.new(
          'akerl/targit', 'new_release', create: true, authfile: 'spec/.creds'
        )
        expect(release.repo).to eql 'akerl/targit'
      end
    end
  end
end
