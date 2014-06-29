module Targit
  ##
  # GitHub Release object
  class Release
    attr_reader :data

    def initialize(client, repo, tag, params = {})
      @client = client
      @options = params
      @repo = repo
      @tag = tag
      @create_options = _create_options
      @data = find
      create(params) if @data.nil? && @options[:create]
    end

    private

    def find
      @client.releases(@repo).find do |x|
        x[:tag_name] == @tag
      end
    end

    def create
      @client.create_release(@repo, @tag)
      @data = find
    end

    def _create_options
      [:prerelease, :target_commitish].each_with_object({}) do |option, hash|
        hash[option] = @options[option] if @options[option]
      end
    end
  end
end
