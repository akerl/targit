require 'octokit'
require 'octoauth'

module Targit
  ##
  # Define asset object for a release
  class Asset
    attr_reader :release, :asset, :name, :github_data

    def initialize(asset, params = {})
      @options = params
      @config = _config
      @client = _client
      @release = _release
      @upload_options = _options
      @asset = asset
      @name = @upload_options[:name] || File.basename(@asset)
    end

    def upload!
      delete! if @options[:force]
      fail('Release asset already exists') if already_exists?
      @client.upload_asset @release[:url], @asset, @options
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
      @client.release_assets(@release[:url]).find { |x| x[:name] == @name }
    end

    private

    def _config
      @options[:authfile] ||= Octoauth::DEFAULT_FILE
      @options[:autosave] ||= true
      Octoauth.new(
        note: 'targit',
        file: @options[:authfile],
        autosave: @options[:autosave]
      )
    end

    def _client
      Octokit::Client.new(
        access_token: @config.token,
        api_endpoint: @options[:api_endpoint],
        web_endpoint: @options[:api_endpoint],
        auto_paginate: true
      )
    end

    def _release
      Targit::Release.new(@client, @options).data
    end

    def _options
      [:name, :content_type].each_with_object({}) do |option, hash|
        hash[option] = @options[option] if @options[option]
      end
    end
  end
end
