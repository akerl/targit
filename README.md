targit
=========

[![Gem Version](https://img.shields.io/gem/v/targit.svg)](https://rubygems.org/gems/targit)
[![Dependency Status](https://img.shields.io/gemnasium/akerl/targit.svg)](https://gemnasium.com/akerl/targit)
[![Code Climate](https://img.shields.io/codeclimate/github/akerl/targit.svg)](https://codeclimate.com/github/akerl/targit)
[![Coverage Status](https://img.shields.io/coveralls/akerl/targit.svg)](https://coveralls.io/r/akerl/targit)
[![Build Status](https://img.shields.io/travis/akerl/targit.svg)](https://travis-ci.org/akerl/targit)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

Manages GitHub release assets for pushing binaries and other large files

## Usage

To upload a file as a release asset:

```
targit USER/REPO TAG /path/to/file
```

That will add the given file as a release asset for "TAG" on the given GitHub repo. If you haven't already stored GitHub credentials, it will prompt you for them.

To create a release that doesn't already exist, add `-c`:

```
targit -c dock0/arch v0.1.75 ./new_tarball.tar.gz
```

Adding `-f` will replace an existing release/asset, if they exist:

```
targit -f -c dock0/arch v0.1.75 ./newer_tarball.tar.gz
```

Use `-n NAME` to set the name for the asset (it defaults to the file's name):

```
targit -n special.tar.gz -f -c dock0/arch v0.1.76 ./custom_tarball.tar.gz
```

Content can also be provided via stdin:

```
echo "secrit data" | targit -f -c -n foobar dock0/arch v0.0.test
```

The release can be created as a prerelease via -p.

Using `-a` lets you use an alternate GitHub credential file, other than the default of `~/.octoauth.yml`.

## Installation

    gem install targit

## Contributors

* [Jon Chen](https://github.com/fly) for suggesting release assets for storing large files, and for coming up with the workflow that this gem is built to streamline.

## License

targit is released under the MIT License. See the bundled LICENSE file for details.

