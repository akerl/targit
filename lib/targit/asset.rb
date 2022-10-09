require 'octokit'
require 'octoauth'
require 'mime-types'

module Targit
  ##
  # Define asset object for a release
  class Asset
    include Targit::Client

    attr_reader :release, :asset, :name

    def initialize(asset, repo, tag, params = {})
      @options = params
      @options[:client] ||= client
      @release = _release repo, tag
      @asset = asset
      @upload_options = _upload_options
      @name = @options[:name] || File.basename(@asset)
    end

    def upload!(retries = 2) # rubocop:disable Metrics/AbcSize
      delete! if @options[:force]
      raise('Release asset already exists') if already_exists?
      asset = client.upload_asset @release.data[:url], @asset, @upload_options
      sleep 1
      client.release_asset asset[:url]
    rescue Errno::ECONNRESET
      raise if retries.zero?
      puts "Retrying upload for #{@asset}"
      sleep 5
      upload!(retries - 1)
    end

    def already_exists?
      github_data != nil
    end

    def delete!
      asset = github_data
      return unless asset
      client.delete_release_asset asset[:url]
    end

    def github_data
      client.release_assets(@release.data[:url]).find { |x| x[:name] == @name }
    end

    def url
      data = github_data
      data ? data[:browser_download_url] : raise('Asset URL not found')
    end

    private

    def _release(repo, tag)
      Targit::Release.new(repo, tag, @options)
    end

    def _upload_options
      options = %i[name content_type].each_with_object({}) do |option, hash|
        hash[option] = @options[option] if @options[option]
      end
      options[:content_type] ||= guess_type
      options
    end

    def guess_type
      mime_type = MIME::Types.type_for(@asset).first
      mime_type ? mime_type.content_type : 'application/octet-stream'
    end
  end
end
