#!/bin/sh

FILE=${1:-$FILE}
FILE=${FILE:-/tmp/out.json}

[ -f "$FILE" ] || echo '[]' >"$FILE"

OUT=$(echo "${2:-$(cat -)}" | jq --compact-output)

INDEX=$(jq '. | length' "$FILE")

echo '[]' | \
  add_json_with_ids --argjson j "$(cat /tmp/out.json)" --arg i 0 &&
  add_json_with_ids --argjson j "$OUT" \
  --arg i "$INDEX" "$FILE" >"$FILE.tmp" &&
	mv "$FILE.tmp" "$FILE" &&
	jq . "$FILE"
