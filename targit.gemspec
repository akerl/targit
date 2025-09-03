require 'English'
$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'targit/version'

Gem::Specification.new do |s|
  s.name        = 'targit'
  s.version     = Targit::VERSION

  s.required_ruby_version = '>= 3.0'

  s.summary     = 'Tool for adding GitHub release assets'
  s.description = 'Manages GitHub release assets for pushing binaries and other large files'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/targit'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.executables = ['targit']

  s.add_dependency 'faraday-multipart', '~> 1.1.1'
  s.add_dependency 'mercenary', '~> 0.4.0'
  s.add_dependency 'mime-types', '~> 3.7.0'
  s.add_dependency 'octoauth', '~> 2.0.1'
  s.add_dependency 'octokit', '~> 10.0.0'

  s.add_development_dependency 'goodcop', '~> 0.9.7'
  s.add_development_dependency 'vcr', '~> 6.3.1'
  s.add_development_dependency 'webmock', '~> 3.25.1'

  s.metadata['rubygems_mfa_required'] = 'true'
end
