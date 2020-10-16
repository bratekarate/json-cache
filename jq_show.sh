#!/bin/sh

FILE=${1:-$FILE}
FILE=${FILE:-/tmp/out.json}

[ -f "$FILE" ] || echo '[]' >"$FILE"

jq . "$FILE"
