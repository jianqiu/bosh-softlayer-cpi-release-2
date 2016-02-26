#!/usr/bin/env bash

set -e

source /etc/profile.d/chruby.sh
chruby 2.1.2

source .envrc

semver=`cat version-semver/number`

pushd bosh-cpi-release
  #echo "running unit tests"
  #pushd src/github.com/maximilien/bosh-softlayer-cpi
    # bin/test
  #popd

  echo "installing bosh CLI"
  gem install bosh_cli --no-ri --no-rdoc

  echo "using bosh CLI version..."
  bosh version

  cpi_release_name="bosh-softlayer-cpi"

  echo "building CPI release..."
  bosh create release --name $cpi_release_name --version $semver --with-tarball
popd

mv bosh-cpi-release/dev_releases/$cpi_release_name/$cpi_release_name-$semver.tgz candidate/











