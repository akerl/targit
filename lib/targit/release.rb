module Targit
  ##
  # GitHub Release object
  class Release
    include Targit::Client

    attr_reader :repo, :tag

    def initialize(repo, tag, params = {})
      @repo = repo
      @tag = tag
      @options = params
      @options[:client] ||= client
      create if @options.include?(:create) && data.nil?
      raise('No release found') if data.nil?
    end

    def data
      @data ||= _data
    end

    private

    def _data
      client.releases(@repo).find { |x| x[:tag_name] == @tag }
    end

    def create
      client.create_release(@repo, @tag, create_options)
    end

    def create_options
      opts = {}
      opts[:name] = @options[:release_name] if @options[:release_name]
      [:prerelease, :target_commitish].each_with_object(opts) do |option, hash|
        hash[option] = @options[option] if @options[option]
      end
    end
  end
end
