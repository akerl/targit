require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '/spec/'
end

require 'rspec'
require 'targit'

require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.before_record do |i|
    i.request.headers.delete 'Authorization'
    %w(Etag X-Github-Request-Id X-Served-By).each do |header|
      i.response.headers.delete header
    end
  end
end
