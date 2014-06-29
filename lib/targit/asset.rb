require 'octokit'
require 'octoauth'

module Targit
  ##
  # Define asset object for a release
  class Asset
    attr_reader :config, :client, :release

    def initialize(params = {})
      @config = _config params
      @client = _client
      @release = _release params
    end

    private

    def _config(params)
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
      @client.releases(params[:repo])
    end
  end
end
