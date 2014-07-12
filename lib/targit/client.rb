require 'octokit'
require 'octoauth'

module Targit
  ##
  # Helper module to load a GitHub API client object
  module Client
    private

    def _client
      file = @options[:authfile] || Octoauth::DEFAULT_FILE
      autosave = @options[:autosave] || true
      auth = Octoauth.new note: 'targit', file: file, autosave: autosave
      Octokit::Client.new(
        access_token: auth.token,
        api_endpoint: @options[:api_endpoint],
        web_endpoint: @options[:api_endpoint],
        auto_paginate: true
      )
    end
  end
end
