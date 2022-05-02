require 'octokit'
require 'octoauth'

Faraday.default_adapter = :httpclient

module Targit
  ##
  # Helper module to load a GitHub API client object
  module Client
    private

    def client
      @client ||= _client
    end

    def _client
      auth = Octoauth.new octoauth_options
      Octokit::Client.new({
        access_token: auth.token,
        api_endpoint: @options[:api_endpoint],
        web_endpoint: @options[:api_endpoint],
        auto_paginate: true
      }.compact)
    end

    def octoauth_options
      {
        note: 'targit',
        files: authfiles,
        autosave: @options[:autosave] || true,
        api_endpoint: @options[:api_endpoint],
        scopes: ['public_repo']
      }
    end

    def authfiles
      return [:default] unless @options[:authfile]
      @authfiles ||= @options[:authfile].split(',')
    end
  end
end
