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
      auth = Octoauth.new octoauth_options
      Octokit::Client.new({
        access_token: auth.token,
        api_endpoint: @options[:api_endpoint],
        web_endpoint: @options[:api_endpoint],
        auto_paginate: true,
        middleware: middleware
      }.compact)
    end

    def middleware
      @middleware ||= Faraday::RackBuilder.new do |builder|
        builder.use Octokit::Response::RaiseError
        builder.request :multipart
        builder.adapter :http
      end
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
