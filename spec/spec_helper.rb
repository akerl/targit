if ENV['CI'] == 'true'
  require 'simplecov'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'rspec'
require 'targit'
require 'webmock'

WebMock.enable!

unless File.exist? 'spec/.creds'
  File.open('spec/.creds', 'w') do |fh|
    fh << "---\ntargit: sekritkey\n"
  end
end

require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.before_record do |i|
    i.request.headers.delete 'Authorization'
    %w[Etag X-Github-Request-Id X-Served-By].each do |header|
      i.response.headers.delete header
    end
  end
end
