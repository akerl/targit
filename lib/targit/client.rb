require 'octokit'
require 'octoauth'

module Targit
  ##
  # Helper module to load a GitHub API client object
  module Client
    private

    def client
      @client ||= _client
    end

    def _client
      autosave = @options[:autosave] || true
      auth = Octoauth.new note: 'targit', files: authfiles, autosave: autosave
      Octokit::Client.new(
        access_token: auth.token,
        api_endpoint: @options[:api_endpoint],
        web_endpoint: @options[:api_endpoint],
        auto_paginate: true
      )
    end

    def authfiles
      return [:default] unless @options[:authfile]
      @authfile ||= @options[:authfile].split(',')
    end
  end
end
