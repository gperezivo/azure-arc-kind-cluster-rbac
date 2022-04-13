#!/bin/bash
. ./variables.sh

set -e 
eval "cat <<EOF
$(<$1)
EOF
"