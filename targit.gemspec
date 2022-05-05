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
  s.test_files  = `git ls-files spec/*`.split
  s.executables = ['targit']

  s.add_dependency 'httpclient', '~> 2.8.3'
  s.add_dependency 'mercenary', '~> 0.4.0'
  s.add_dependency 'mime-types', '~> 3.4.1'
  s.add_dependency 'octoauth', '~> 1.9.0'
  s.add_dependency 'octokit', '~> 4.22.0'

  s.add_development_dependency 'goodcop', '~> 0.9.5'
  s.add_development_dependency 'vcr', '~> 5.0.0'
  s.add_development_dependency 'webmock', '~> 3.8.0'

  s.metadata['rubygems_mfa_required'] = 'true'
end
