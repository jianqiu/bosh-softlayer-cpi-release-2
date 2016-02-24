#!/usr/bin/env bash

set -e -x

mkdir out

dev_version=`cat dev-version/number`

cd bosh-softlayer-cpi-release

source .envrc

./src/github.com/maximilien/bosh-softlayer-cpi/bin/test

# todo remove installation
gem install bosh_cli --no-ri --no-rdoc

bosh -n create release --version $dev_version --with-tarball

mv dev_releases/bosh-softlayer-cpi/*.tgz ../out/