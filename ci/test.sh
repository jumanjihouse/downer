#!/bin/bash
set -eEu
set -o pipefail

# shellcheck disable=SC1091
. ci/vars

# Ensure dependencies are up-to-date.
# shellcheck disable=SC1091
. ci/bootstrap.sh

# Run various checks unrelated to Puppet.
run_precommit

# Run unit and acceptance tests.
bats ci/*.bats
