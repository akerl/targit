##
# This module provides a simple interface to GitHub's release assets
module Targit
  class << self
    ##
    # Insert a helper .new() method for creating a new Cache object

    def new(*args)
      self::Asset.new(*args)
    end
  end
end

require 'targit/asset'
