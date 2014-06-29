require 'octokit'
require 'octoauth'

module Targit
  ##
  # Define asset object for a release
  class Asset
    attr_reader :release, :asset

    def initialize(asset, params = {})
      @config = _config params
      @client = _client params
      @release = _release params
      @asset = asset
      @name = params[:name]
      @content_type = params[:content_type]
    end

    def upload!
      url = @release[:url]
      options = {}
      options[:name] = @name if @name
      options[:content_type] = @content_type
      @client.upload_asset url, @asset, options
    end

    private

    def _config(params)
      params[:authfile] ||= Octoauth::DEFAULT_FILE
      Octoauth.new(
        note: 'targit',
        file: params[:authfile],
        autosave: true
      )
    end

    def _client(params)
      Octokit::Client.new(
        access_token: @config.token,
        api_endpoint: params[:api_endpoint],
        web_endpoint: params[:api_endpoint]
      )
    end

    def _release(params)
      params = params.dup
      params[:client] = @client
      Targit::Release.new(params).data
    end
  end
end