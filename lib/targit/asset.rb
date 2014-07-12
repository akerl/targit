require 'octokit'
require 'octoauth'
require 'mime-types'

module Targit
  ##
  # Define asset object for a release
  class Asset
    include Targit::Client

    attr_reader :release, :asset, :name, :github_data

    def initialize(asset, repo, tag, params = {})
      @options = params
      @options[:client] ||= _client
      @client = @options[:client]
      @release = _release repo, tag
      @upload_options = _upload_options
      @asset = asset
      @name = @options[:name] || File.basename(@asset)
    end

    def upload!
      delete! if @options[:force]
      fail('Release asset already exists') if already_exists?
      asset = @client.upload_asset @release.data[:url], @asset, @upload_options
      @client.release_asset asset[:url]
    end

    def already_exists?
      github_data != nil
    end

    def delete!
      asset = github_data
      return unless asset
      @client.delete_release_asset asset[:url]
    end

    def github_data
      @client.release_assets(@release.data[:url]).find { |x| x[:name] == @name }
    end

    def url
      data = github_data
      data ? data[:browser_download_url] : fail('Asset URL not found')
    end

    private

    def _release(repo, tag)
      Targit::Release.new(repo, tag, @options)
    end

    def _upload_options
      options = [:name, :content_type].each_with_object({}) do |option, hash|
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
