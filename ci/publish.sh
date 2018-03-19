#!/bin/bash
set -eEu
set -o pipefail

# shellcheck disable=SC1091
. ci/vars

docker login -u "${USER}" -p "${PASS}"
docker-compose push
docker logout
