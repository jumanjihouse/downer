#!/bin/bash
set -eEu
set -o pipefail

cat > ci/vars <<EOF
declare -rx VERSION="1.79.0"

BUILD_DATE="$(date +%Y%m%dT%H%M)"
declare -rx BUILD_DATE

VCS_REF="$(git rev-parse --short HEAD)"
declare -rx VCS_REF

declare -rx TAG="\${VERSION}-\${BUILD_DATE}-git-\${VCS_REF}"
EOF

# shellcheck disable=SC1091
. ci/vars

docker-compose build
