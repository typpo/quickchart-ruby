#!/bin/bash -e

pushd $(dirname $0) &>/dev/null

cd ..
gem build quickchart.gemspec

popd &>/dev/null
