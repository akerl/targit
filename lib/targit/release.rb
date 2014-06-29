module Targit
  ##
  # GitHub Release object
  class Release
    attr_reader :data

    def initialize(client, params = {})
      @client = client
      @data = find params
      create(params) if @data.nil? && params[:create]
    end

    private

    def find(params)
      @client.releases(params[:repo]).find do |x|
        x[:tag_name] == params[:tag]
      end
    end

    def create(params)
      @client.create_release(params[:repo], params[:tag])
      params[:create] = false
      find params
    end
  end
end
