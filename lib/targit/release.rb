module Targit
  ##
  # GitHub Release object
  class Release
    include Targit::Client

    attr_reader :data, :repo, :tag

    def initialize(repo, tag, params = {})
      @repo, @tag, @options = repo, tag, params
      @options[:client] ||= _client
      @client = @options[:client]
      @create_options = _create_options
      @data = find
      create if @data.nil? && @options.include?(:create)
      fail('No release found') if @data.nil?
    end

    private

    def find
      @client.releases(@repo).find do |x|
        x[:tag_name] == @tag
      end
    end

    def create
      @client.create_release(@repo, @tag, @create_options)
      @data = find
    end

    def _create_options
      opts = {}
      opts[:name] = @options[:release_name] if @options[:release_name]
      [:prerelease, :target_commitish].each_with_object(opts) do |option, hash|
        hash[option] = @options[option] if @options[option]
      end
    end
  end
end
