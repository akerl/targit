$:.unshift File.expand_path('../lib/', __FILE__)
require 'targit/version'

Gem::Specification.new do |s|
  s.name        = 'targit'
  s.version     = Targit::VERSION
  s.date        = Time.now.strftime("%Y-%m-%d")

  s.summary     = 'Tool for adding GitHub release assets'
  s.description = "Manages GitHub release assets for pushing binaries and other large files"
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/targit'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split
  s.executables = ['targit']

  s.add_dependency 'octokit', '~> 3.7.0'
  s.add_dependency 'octoauth', '~> 1.0.0'
  s.add_dependency 'mercenary', '~> 0.3.4'
  s.add_dependency 'mime-types', '~> 2.3'

  s.add_development_dependency 'rubocop', '~> 0.29.0'
  s.add_development_dependency 'rake', '~> 10.4.0'
  s.add_development_dependency 'coveralls', '~> 0.7.1'
  s.add_development_dependency 'rspec', '~> 3.2.0'
  s.add_development_dependency 'fuubar', '~> 2.0.0'
  s.add_development_dependency 'webmock', '~> 1.20.2'
  s.add_development_dependency 'vcr', '~> 2.9.2'
end
