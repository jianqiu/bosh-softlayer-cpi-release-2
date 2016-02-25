#!/usr/bin/env bash

set -e

semver=`cat version-semver/number`

mkdir out

cd bosh-cpi-release

source .envrc

echo "running unit tests"
./src/github.com/maximilien/bosh-softlayer-cpi/bin/test-unit

echo "using bosh CLI version..."
bosh version

cpi_release_name="bosh-softlayer-cpi"

echo "building CPI release..."
bosh create release --name $cpi_release_name --version $semver --with-tarball

mv dev_releases/$cpi_release_name/$cpi_release_name-$semver.tgz ../out/
