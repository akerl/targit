require 'rspec'
require 'targit'
require 'webmock/rspec'
require 'vcr'

unless File.exist? 'spec/.creds'
  File.open('spec/.creds', 'w') do |fh|
    fh << "---\ntargit: sekritkey\n"
  end
end

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.before_record do |i|
    i.request.headers.delete 'Authorization'
    %w[Etag X-Github-Request-Id X-Served-By].each do |header|
      i.response.headers.delete header
    end
  end
end
