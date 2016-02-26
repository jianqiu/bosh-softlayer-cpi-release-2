#!/usr/bin/env bash

set -e

semver=`cat version-semver/number`

mkdir out

cd bosh-cpi-release

source .envrc

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
bosh create release --name $cpi_release_name --version $semver --with-tarball --force

mv dev_releases/$cpi_release_name/$cpi_release_name-$semver.tgz ../out/
